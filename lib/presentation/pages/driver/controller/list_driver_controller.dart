import 'package:flutter/material.dart';
import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/presentation/pages/driver/event/list_driver_event.dart';
import 'package:mobile_manager_car/presentation/pages/driver/state/list_driver_state.dart';

import '../../../../domain/usecase/driver_usecase.dart';
import '../../../component/single_value_notifier.dart';

class ListDriverController {
  final DriverUseCase _driverUseCase;

  ListDriverController(this._driverUseCase);

  SingleValueNotifier action = SingleValueNotifier(ListDriverEvent());
  ValueNotifier<ListDriverState> state = ValueNotifier(ListDriverState());

  getAllDrivers() async {
    state.value.isLoading = true;
    _notifyState();
    await _driverUseCase.getAllDrivers().either(
      (error) {
        state.value = ListDriverState.showError();
        _notifyState();
      },
      (data) {
        state.value = ListDriverState.success(data);
        _notifyState();
      },
    );
  }

  void _notifyState() {
    state.value = ListDriverState.copy(state.value);
  }
}
