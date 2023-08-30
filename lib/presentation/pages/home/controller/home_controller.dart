import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/car_driver.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';
import 'package:mobile_manager_car/domain/model/reminder_check.dart';
import 'package:mobile_manager_car/domain/usecase/car_usecase.dart';
import 'package:mobile_manager_car/domain/usecase/driver_usecase.dart';
import 'package:mobile_manager_car/domain/usecase/metric_usecase.dart';
import 'package:mobile_manager_car/domain/usecase/reminder_usecase.dart';
import 'package:mobile_manager_car/presentation/pages/car/event/list_car_event.dart';
import 'package:mobile_manager_car/presentation/pages/car/state/list_car_state.dart';
import 'package:mobile_manager_car/presentation/pages/home/event/home_event.dart';
import 'package:week_of_year/week_of_year.dart';

import '../../../../domain/model/car.dart';
import '../../../../domain/model/driver.dart';
import '../../../../domain/usecase/historic_usecase.dart';
import '../../../../domain/usecase/reminder_rent_values_usecase.dart';
import '../../../component/single_value_notifier.dart';
import '../state/home_state.dart';

class HomeController {
  final CarUseCase _carUseCase;
  final HistoricUseCase _historicUseCase;
  final ReminderUseCase _reminderUseCase;
  final MetricUseCase _metricUseCase;
  final ReminderRentValuesUseCase _reminderRentValuesUseCase;

  HomeController(this._carUseCase, this._historicUseCase, this._reminderUseCase, this._metricUseCase, this._reminderRentValuesUseCase);

  SingleValueNotifier action = SingleValueNotifier(HomeEvent());
  ValueNotifier<HomeState> state = ValueNotifier(HomeState());

  static const limitCar = 5;
  static const limitHistory = 10;

  void init() {
    getCarsByLimit(DateTime.now().year, DateTime.now().weekOfYear);
    getAllMetrics(DateTime.now().year, DateTime.now().weekOfYear);
    getAllTimeline();
  }

  Future<void> getAllMetrics(int year, int weekYear) async {
    state.value.homeMetricsState.isLoading = true;
    _notifyState();
    await _metricUseCase.getGeneralMetricByWeek(year, weekYear).either((error) {
      state.value.homeMetricsState.isSuccess = false;
      state.value.homeMetricsState.isLoading = false;
      state.value.homeMetricsState.isError = true;
      state.value.homeMetricsState.isEmpty = false;
      _notifyState();
    }, (data) {
      var positiveValue = data?.profit.sum((item) => item.value) ?? 0;
      var negativeValue = data?.debits.sum((item) => item.value) ?? 0;
      state.value.homeMetricsState.isLoading = false;
      state.value.homeMetricsState.isError = false;
      state.value.homeMetricsState.isSuccess = data != null;
      state.value.homeMetricsState.isEmpty = data == null;
      state.value.homeMetricsState.positiveValue = positiveValue;
      state.value.homeMetricsState.negativeValue = negativeValue;
      _notifyState();
    });
  }

  Future<void> getCarsByLimit(int year, int weekYear) async {
    state.value.homeCarState.isLoading = true;
    state.value.homeReminderState.isLoading = true;
    _notifyState();
    await _carUseCase.getAllCars().either((error) {
      state.value.homeCarState.isSuccess = false;
      state.value.homeCarState.isLoading = false;
      state.value.homeCarState.isError = true;
      state.value.homeCarState.isEmpty = false;
      _notifyState();
    }, (data) {
      state.value.homeCarState.isLoading = false;
      state.value.homeCarState.isError = false;
      state.value.homeCarState.isSuccess = data.isNotEmpty;
      state.value.homeCarState.isEmpty = data.isEmpty;
      state.value.homeCarState.cars = data.take(limitCar).toList(growable: true);
      getAllReminders(year, weekYear);
      _notifyState();
    });
  }

  Future<void> getAllReminders(int year, int weekYear) async {
    var carsRunning = state.value.homeCarState.cars.filterItems((car) => car.carDriver != null && !car.inMaintenance);
    await _reminderUseCase.getAllReminderCars(year, weekYear, carsRunning).either((error) {
      state.value.homeReminderState.isSuccess = false;
      state.value.homeReminderState.isLoading = false;
      state.value.homeReminderState.isError = true;
      state.value.homeReminderState.isEmpty = false;
      _notifyState();
    }, (data) {
      List<String> listReminder = [];

      List<String> reminderPaymentCars = _reminderRentValuesUseCase.get(carsRunning, data, weekYear);

      listReminder.addAll(reminderPaymentCars);

      state.value.homeReminderState.isLoading = false;
      state.value.homeReminderState.isError = false;
      state.value.homeReminderState.isSuccess = listReminder.isNotEmpty;
      state.value.homeReminderState.isEmpty = listReminder.isEmpty;
      state.value.homeReminderState.reminders = listReminder;
      _notifyState();
    });
  }

  Future<void> getAllTimeline() async {
    state.value.homeHistoryState.isLoading = true;
    _notifyState();
    await _historicUseCase.getAllHistoric(limitHistory).either((error) {
      state.value.homeHistoryState.isSuccess = false;
      state.value.homeHistoryState.isLoading = false;
      state.value.homeHistoryState.isError = true;
      state.value.homeHistoryState.isEmpty = false;
      _notifyState();
    }, (data) {
      state.value.homeHistoryState.isLoading = false;
      state.value.homeHistoryState.isError = false;
      state.value.homeHistoryState.isSuccess = data.isNotEmpty;
      state.value.homeHistoryState.isEmpty = data.isEmpty;
      state.value.homeHistoryState.histories = data.take(limitHistory).toList(growable: true);
      _notifyState();
    });
  }

  void _notifyState() {
    state.value = HomeState.copy(state.value);
  }

  void refresh(int year, int weekYear) {
    getAllMetrics(year, weekYear);
    getAllReminders(year, weekYear);
    getAllMetrics(year, weekYear);
  }
}
