import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobile_manager_car/domain/usecase/user_usecase.dart';
import 'package:mobile_manager_car/presentation/pages/authentication/event/login_event.dart';

import '../../../../data/datasource/preferences/Preferences.dart';
import '../../../component/single_value_notifier.dart';
import '../state/login_state.dart';

class LoginController {
  final UserUseCase userUseCase;
  final Preferences _preferences;

  LoginController(this.userUseCase, this._preferences);

  SingleValueNotifier<LoginEvent> action = SingleValueNotifier(LoginEvent());
  ValueNotifier<LoginState> state = ValueNotifier(LoginState());

  verifyIfShowAuthenticateBiometrics() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    String email = await _preferences.getString(Preferences.emailKey);
    String password = await _preferences.getString(Preferences.passwordKey);
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    if (canCheckBiometrics && email.isNotEmpty && password.isNotEmpty) {
      _updateState(LoginState(showBiometric: true));
    }
  }

  doLoginBiometric(bool authenticated) async {
    if (authenticated) {
      String email = await _preferences.getString(Preferences.emailKey);
      String password = await _preferences.getString(Preferences.passwordKey);
      doLogin(email, password);
    }
  }

  doLogin(String email, String password) async {
    _updateState(LoginState(isLoading: true));
    await userUseCase.doLogin(email, password).either((error) {
      action.value = ShowNegativeMessage(error.message);
    }, (success) {
      _preferences.saveString(Preferences.emailKey, email);
      _preferences.saveString(Preferences.passwordKey, password);
      action.value = GoToHome();
    });
    _updateState(LoginState(isLoading: false));
  }

  void _updateState(LoginState? newState) {
    state.value = LoginState.copy(newState ?? state.value);
  }
}
