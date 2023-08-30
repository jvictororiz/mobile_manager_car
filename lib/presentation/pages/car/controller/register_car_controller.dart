import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/usecase/car_usecase.dart';
import 'package:mobile_manager_car/presentation/pages/car/event/register_car_event.dart';
import 'package:mobile_manager_car/presentation/pages/car/state/register_car_state.dart';

import '../../../../domain/model/car.dart';
import '../../../../domain/model/historic_type.dart';
import '../../../../domain/usecase/historic_usecase.dart';
import '../../../component/single_value_notifier.dart';
import '../../../res/strings.dart';

class RegisterCarController {
  final CarUseCase _carUseCase;
  final HistoricUseCase _historicUseCase;

  RegisterCarController(this._carUseCase, this._historicUseCase);

  SingleValueNotifier action = SingleValueNotifier(RegisterCarEvent());
  ValueNotifier<RegisterCarState> state = ValueNotifier(RegisterCarState());

  init(Car? car) {
    state.value.car = car;
    state.value.editKmEnable = car == null;
    state.value.titleToolbar = car == null ? Strings.registerCar : Strings.updateCar;
    _updateState(state.value);
  }

  registerOrUpdate(Car car, List<File> newImages) async {
    var isRegister = car.id.isEmpty;
    _updateState(RegisterCarState(isLoading: true));
    await _carUseCase.registerOrUpdateCar(car, newImages).either((error) {
      action.value = ShowNegativeMessage(error.message);
    }, (data) async {
      if (isRegister) {
        await _historicUseCase.saveHistoric(car.id, NewCar(car));
      }
      var messageSuccess = isRegister ? "Veículo registrado com sucesso!" : "Veículo alterado com sucesso!";
      action.value = ShowPositiveMessage(messageSuccess);
      action.value = FinishScreen();
    });
    _updateState(RegisterCarState(isLoading: false));
  }

  void deleteImageCar(String urlImage) {
    var car = state.value.car;
    _updateState(RegisterCarState(isLoading: true));
    if (car != null) {
      _carUseCase.deleteImage(car, urlImage.getIdImage()).either(
        (error) {
          action.value = ShowNegativeMessage("Erro ao deletar imagem!");
        },
        (result) {
          state.value.car = result;
          _updateState(state.value);
        },
      );
    }
    _updateState(RegisterCarState(isLoading: false));
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

  void _updateState(RegisterCarState? newState) {
    state.value = RegisterCarState.copy(newState ?? state.value);
  }
}
