import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import '../../../core/exception/exceptions.dart';

class HistoricFirebaseService {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;

  final String TABLE_HISTORIC = "TABLE_HISTORIC";

  HistoricFirebaseService(this.firebaseAuth, this.firebaseDatabase);

  Future addHistoricCar(String idCar, HistoricType historic) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      await firebaseDatabase.ref(id).child(TABLE_HISTORIC).child(idCar).child(DateTime.now().millisecondsSinceEpoch.toString()).set(historic.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<Either<DefaultException, List<HistoricType>>> getAllHistoricByCar(String idCar) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var result = await firebaseDatabase.ref(id).child(TABLE_HISTORIC).child(idCar).get().timeout(const Duration(seconds: 10));
      var listHistoric = result.children.map((item) {
        return HistoricType.fromSnapshot(item.value as Map<dynamic, dynamic>);
      }).toList(growable: true);
      return Right(listHistoric.reversed.toList(growable: true));
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar o histórico do veículo, verifique a sua conexão."));
    }
  }

  Future<Either<DefaultException, List<HistoricType>>> getAllHistoric(int? limit) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var tableHistory = firebaseDatabase.ref(id).child(TABLE_HISTORIC);
      if (limit != null) {
        tableHistory.limitToFirst(limit);
      }
      var result = await tableHistory.get().timeout(const Duration(seconds: 10));
      var listHistoric = result.children.map((item) {
        var map = item.value as Map<dynamic, dynamic>;
        List values = map.values.toList(growable: true);
        return values.map((itemInternal) => HistoricType.fromSnapshot(itemInternal)).toList(growable: true);
      }).toList(growable: true);
      return Right(listHistoric.flatten());
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar o histórico, verifique a sua conexão."));
    }
  }
}
