import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/usecase/car_usecase.dart';
import 'package:mobile_manager_car/presentation/pages/driver/event/register_driver_event.dart';
import 'package:mobile_manager_car/presentation/pages/driver/state/register_driver_state.dart';

import '../../../../domain/model/driver.dart';
import '../../../../domain/usecase/driver_usecase.dart';
import '../../../component/single_value_notifier.dart';
import '../../../res/strings.dart';

class RegisterDriverController {
  final DriverUseCase _driverUseCase;
  final CarUseCase _carUseCase;

  RegisterDriverController(this._driverUseCase, this._carUseCase);

  SingleValueNotifier action = SingleValueNotifier(RegisterDriverEvent());
  ValueNotifier<RegisterDriverState> state = ValueNotifier(RegisterDriverState());

  init(Driver? driver) {
    state.value.driver = driver;
    state.value.titleToolbar = driver == null ? Strings.registerDriver : Strings.updateDriver;
    _updateState(state.value);
  }

  registerOrUpdate(Driver driver, List<File> newImages) async {
    var idCar = driver.idCar;
    _updateState(RegisterDriverState(isLoading: true));
    await _driverUseCase.registerOrUpdateCar(driver, newImages).either((error) {
      action.value = ShowNegativeMessage(error.message);
    }, (data) async {
      await _linkDriverIfContainsCar(idCar, driver);
      print(idCar);
      var messageSuccess = idCar != null ? "Motorista cadastrado com sucesso!" : "Motorista alterado com sucesso!";
      action.value = ShowPositiveMessage(messageSuccess);
      action.value = FinishScreen();
    });
    _updateState(RegisterDriverState(isLoading: false));
  }

  Future<void> _linkDriverIfContainsCar(String? idCar, Driver driver) async {
    if (idCar != null && idCar.isNotEmpty) {
      var result = await _carUseCase.getCarById(idCar);
      if(result.isRight){
        var car = result.right;
        var dayWeekPayment = car.carDriver?.dayWeekPayment ?? 1;
        var valueRent = car.carDriver?.valueRent ?? car.valueDefaultRent;
        if (result.isRight) {
          await _carUseCase.linkDriver(car, driver, dayWeekPayment, valueRent);
        }
      }


    }
  }

  void deleteImageCar(String urlImage) {
    var driver = state.value.driver;
    _updateState(RegisterDriverState(isLoading: true));
    if (driver != null) {
      _driverUseCase.deleteImage(driver, urlImage.getIdImage()).either(
        (error) {
          action.value = ShowNegativeMessage("Erro ao deletar imagem!");
        },
        (result) {
          state.value.driver = result;
          _updateState(state.value);
        },
      );
    }
    _updateState(RegisterDriverState(isLoading: false));
  }

  void saveImageGallery(String urlImage) async {
    state.value.isLoading = true;
    _updateState(state.value);
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(urlImage)).load(urlImage)).buffer.asUint8List();
    await ImageGallerySaver.saveImage(bytes.buffer.asUint8List()) as Map<dynamic, dynamic>;
    action.value = ShowPositiveMessage("Imagem enviada para galeria");
    state.value.isLoading = false;
    _updateState(state.value);
  }

  void _updateState(RegisterDriverState? newState) {
    state.value = RegisterDriverState.copy(newState ?? state.value);
  }
}
