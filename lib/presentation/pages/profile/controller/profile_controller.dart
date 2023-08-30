import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_manager_car/presentation/pages/profile/event/profile_event.dart';

import '../../../component/single_value_notifier.dart';
import '../state/profile_state.dart';

class ProfileController {
  final FirebaseAuth _firebaseAuth;

  ProfileController(this._firebaseAuth);

  SingleValueNotifier action = SingleValueNotifier(ProfileEvent());
  ValueNotifier<ProfileState> state = ValueNotifier(ProfileState("", ""));

  init() {
    state.value.nameUser = _firebaseAuth.currentUser?.displayName ?? "";
    state.value.emailUser = _firebaseAuth.currentUser?.email ?? "";
    _notifyState();
  }

  void exit() {
    _firebaseAuth.signOut();
    action.value = ExitPage();
  }

  void _notifyState() {
    state.value = ProfileState.copy(state.value);
  }
}
