import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/data/datasource/firebase/user_firebase_service.dart';

import '../../core/exception/exceptions.dart';
import '../../domain/model/user_model.dart';

class UserRepository {
  final UserFirebaseService _userFirebaseService;

  UserRepository(this._userFirebaseService);

  Future<Either<DefaultException, UserModel>> registerUser(String name, String email, String password) async {
    return _userFirebaseService.registerUser(name, email, password);
  }

  Future<Either<DefaultException, UserModel>> doLogin(String email, String password) async {
    return _userFirebaseService.doLogin(email, password);
  }
}
