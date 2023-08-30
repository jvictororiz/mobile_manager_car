import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_manager_car/domain/usecase/user_usecase.dart';
import 'package:mobile_manager_car/presentation/pages/authentication/state/register_state.dart';

import '../../../../data/datasource/preferences/Preferences.dart';
import '../../../component/single_value_notifier.dart';
import '../event/register_event.dart';

class RegisterController {
  final UserUseCase userUseCase;
  final Preferences _preferences;

  RegisterController(this.userUseCase, this._preferences);

  SingleValueNotifier action = SingleValueNotifier(RegisterEvent());
  ValueNotifier state = ValueNotifier(RegisterState());

  register(String name, String email, String password, String confirmPassword) async {
    _updateState(RegisterState(isLoading: true));
    await userUseCase.registerUser(name, email, password, confirmPassword).either((error) {
      action.value = ShowNegativeMessage(error.message);
    }, (success) {
      _preferences.saveString(Preferences.emailKey, email);
      _preferences.saveString(Preferences.passwordKey, password);
      action.value = GoToHome();
    });
    _updateState(RegisterState(isLoading: false));
  }

  void _updateState(RegisterState? newState) {
    state.value = RegisterState.copy(newState ?? state.value);
  }
}
