import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';
import 'package:mobile_manager_car/domain/usecase/car_usecase.dart';
import 'package:mobile_manager_car/domain/usecase/driver_usecase.dart';
import 'package:mobile_manager_car/presentation/pages/car/event/list_car_event.dart';
import 'package:mobile_manager_car/presentation/pages/car/state/list_car_state.dart';

import '../../../../domain/model/car.dart';
import '../../../../domain/model/driver.dart';
import '../../../../domain/usecase/historic_usecase.dart';
import '../../../component/single_value_notifier.dart';

class ListCarController {
  final CarUseCase _carUseCase;
  final DriverUseCase _driverUseCase;
  final HistoricUseCase _historicUseCase;

  ListCarController(this._carUseCase, this._driverUseCase, this._historicUseCase);

  SingleValueNotifier action = SingleValueNotifier(ListCarEvent());
  ValueNotifier<ListCarState> state = ValueNotifier(ListCarState());

  void showModalListDrivers(Car car) {
    action.value = OpenDriversModal(car);
    _notifyState();
    loadAvailableDrivers();
  }

  void tapOnEditDriver(String idDriver) {
    state.value.isLoading = true;
    _notifyState();
    _driverUseCase.getDriverById(idDriver).either(
      (error) {
        action.value = ShowNegativeMessage(error.message);
      },
      (result) {
        action.value = OpenEditDriver(result);
      },
    );
    state.value.isLoading = false;
    _notifyState();
  }

  void changeDriverInCar(Car car, Driver newDriver, int dayWeekPayment, double valueRent) async {
    var oldDriver = car.carDriver;
    if (oldDriver == null) return;
    if (oldDriver.id == newDriver.id) {
      action.value = ShowNegativeMessage("Esse(a) motorista já está com o contrato desse veículo!");
      return;
    }
    await unlinkDriverInCar(car);
    await linkDriverInCar(car, newDriver, dayWeekPayment, valueRent);
  }

  unlinkDriverInCar(Car car) async {
    var carDriver = car.carDriver;
    if (carDriver == null) return;
    _notifyState();
    await _carUseCase.unLinkDriver(car, carDriver).either(
      (error) {
        action.value = ShowNegativeMessage(error.message);
      },
      (result) async {
        var cars = state.value.cars;
        var index = state.value.cars.indexOf(car);
        cars[index] = result;
        var historicRent = result.historicRent.last;
        await _historicUseCase.saveHistoric(car.id, FinishContract(historicRent));

        state.value = ListCarState.success(cars);
        action.value = ShowPositiveMessage("Motorista desvinculado com sucesso!");
        _setMetrics();
      },
    );
    state.value.isLoading = false;
    _notifyState();
  }

  linkDriverInCar(Car car, Driver driver, int dayWeekPayment, double valueRent) async {
    _notifyState();
    await _carUseCase.linkDriver(car, driver, dayWeekPayment, valueRent).either(
      (error) {
        action.value = ShowNegativeMessage(error.message);
      },
      (result) async {
        var isUpdate = result.carDriver != null;
        var cars = state.value.cars;
        var index = state.value.cars.indexOf(car);
        cars[index] = result;
        await _historicUseCase.saveHistoric(car.id, CarRented(result, valueRent));
        state.value = ListCarState.success(cars);
        var actionUser = isUpdate ? "alterado" : "adicionado";
        action.value = ShowPositiveMessage("Motorista $actionUser com sucesso!");
        _setMetrics();
      },
    );
    state.value.isLoading = false;
    _notifyState();
  }

  void loadAvailableDrivers() {
    action.value = ChangeStatusDriversModal([], isLoading: true);
    _driverUseCase.getAllDrivers().either(
      (error) {
        action.value = action.value = ChangeStatusDriversModal([], isError: true);
      },
      (result) {
        action.value = ChangeStatusDriversModal(result, isSuccess: result.isNotEmpty, isEmpty: result.isEmpty);
      },
    );
  }

  getAllCars() async {
    state.value.isLoading = true;
    _notifyState();
    await _carUseCase.getAllCars().either((error) {
      state.value = ListCarState.showError();
    }, (data) {
      state.value = ListCarState.success(data);
      _setMetrics();
    });
  }

  void _setMetrics() {
    var data = state.value.cars;
    var carsRunning = data.filterItems((item) => item.carDriver != null && !item.inMaintenance).length;
    var carsInMaintenance = data.filterItems((item) => item.inMaintenance).length;
    var carsAvailable = data.filterItems((item) => item.carDriver == null).length;

    state.value.carsRunning = carsRunning;
    state.value.carsInMaintenance = carsInMaintenance;
    state.value.carsAvailable = carsAvailable;
    state.value.percentRunning = _calculatePercentage(carsRunning, carsRunning + carsInMaintenance + carsAvailable);
    _notifyState();
  }

  double _calculatePercentage(int value, int total) {
    return (value / total) * 100;
  }

  void _notifyState() {
    state.value = ListCarState.copy(state.value);
  }
}
