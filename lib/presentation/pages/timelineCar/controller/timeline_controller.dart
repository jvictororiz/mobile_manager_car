import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_car/domain/model/car.dart';
import 'package:mobile_manager_car/presentation/pages/timelineCar/event/timeline_event.dart';

import '../../../../domain/usecase/historic_usecase.dart';
import '../../../component/single_value_notifier.dart';
import '../state/timeline_state.dart';

class TimelineController {
  final HistoricUseCase _historicUseCase;

  TimelineController(this._historicUseCase);

  SingleValueNotifier action = SingleValueNotifier(TimelineEvent());
  ValueNotifier<TimelineState> state = ValueNotifier(TimelineState());

  void init(Car? car) {
    state.value.car = car;
    state.value.titlePage = car != null ? car.model : "Timeline";
    state.value.showButtonAdd = car != null;
    _notifyState();
    refresh();
  }

  void refresh() async {
    var car = state.value.car;
    if (car != null) {
      await _getTimelineByCar();
    } else {
      await _getAllTimeline();
    }
  }

  Future<void> _getAllTimeline() async {
    state.value.isLoading = true;
    _notifyState();
    await _historicUseCase.getAllHistoric(null).either((error) {
      state.value.isSuccess = false;
      state.value.isLoading = false;
      state.value.isError = true;
      state.value.isEmpty = false;
      _notifyState();
    }, (data) {
      state.value.isLoading = false;
      state.value.isError = false;
      state.value.isSuccess = data.isNotEmpty;
      state.value.isEmpty = data.isEmpty;
      state.value.histories = data;
      _notifyState();
    });
  }

  Future<void> _getTimelineByCar() async {
    var idCar = state.value.car?.id;
    if (idCar != null) {
      state.value.isLoading = true;
      _notifyState();
      await _historicUseCase.getAllHistoricByCar(idCar).either((error) {
        state.value.isSuccess = false;
        state.value.isLoading = false;
        state.value.isError = true;
        state.value.isEmpty = false;
        _notifyState();
      }, (data) {
        state.value.isLoading = false;
        state.value.isError = false;
        state.value.isSuccess = data.isNotEmpty;
        state.value.isEmpty = data.isEmpty;
        state.value.histories = data;
        _notifyState();
      });
    }
  }

  void _notifyState() {
    state.value = TimelineState.copy(state.value);
  }
}
