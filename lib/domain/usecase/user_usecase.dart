import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';

import '../../core/exception/exceptions.dart';
import '../../data/repository/user_repository.dart';
import '../model/user_model.dart';

class UserUseCase {
  final UserRepository _userRepository;

  UserUseCase(this._userRepository);

  Future<Either<DefaultException, UserModel>> registerUser(String name, String email, String password, String confirmPassword) async {
    if (name.length < 3) {
      return Left(DefaultException("Nome precisa ter pelo menos 3 caracteres"));
    }
    if (!email.isValidEmail()) {
      return Left(DefaultException("E-mail não é válido"));
    }
    if (password.length < 2 && confirmPassword.length < 2) {
      return Left(DefaultException("Preencha a senha corretamente"));
    }
    if (password != confirmPassword) {
      return Left(DefaultException("Senhas não correspondem"));
    }
    return _userRepository.registerUser(name, email, password);
  }

  Future<Either<DefaultException, UserModel>> doLogin(String email, String password) async {
    if (!email.isValidEmail()) {
      return Left(DefaultException("E-mail não é válido"));
    }
    if (password.length < 2) {
      return Left(DefaultException("Preencha a senha corretamente"));
    }
    return _userRepository.doLogin(email, password);
  }
}
