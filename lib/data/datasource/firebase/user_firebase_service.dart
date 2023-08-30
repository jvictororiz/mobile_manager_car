import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/exception/exceptions.dart';
import '../../../domain/model/user_model.dart';

class UserFirebaseService {
  final FirebaseAuth firebaseAuth;

  UserFirebaseService(this.firebaseAuth);

  Future<Either<DefaultException, UserModel>> registerUser(String name, String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firebaseAuth.currentUser?.updateDisplayName(name);
      firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      String id = credential.user?.uid ?? "";
      return Right(UserModel(id, name, email));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print(e);
        return Left(DefaultException("Sua senha é muito fraca, por favor, escolha uma senha mais forte"));
      } else if (e.code == 'email-already-in-use') {
        return Left(DefaultException("E-mail já cadastrado"));
      } else {
        return Left(DefaultException("Não foi possível realizar o cadastro, por favor, tente novamente mais tarde"));
      }
    } on FirebaseException catch (_) {
      firebaseAuth.currentUser?.delete();
      return Left(DefaultException("Houve um erro ao fazer o upload de sua imagem"));
    } catch (e) {
      return Left(DefaultException("Não foi possível realizar o cadastro, por favor, tente novamente mais tarde"));
    }
  }

  Future<Either<DefaultException, UserModel>> doLogin(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return Right(UserModel(credential.user?.uid ?? "", credential.user?.displayName ?? "", credential.user?.email ?? ""));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(DefaultException("Não existe conta com esse e-mail, por favor, realize o cadastro."));
      } else if (e.code == 'wrong-password') {
        return Left(DefaultException("Senha incorreta, por favor, tente novamente."));
      } else {
        return Left(DefaultException("Houve um erro inesperado, tente novamente mais tarde."));
      }
    } catch (ex) {
      return Left(DefaultException("Houve um erro inesperado, tente novamente mais tarde."));
    }
  }
}
