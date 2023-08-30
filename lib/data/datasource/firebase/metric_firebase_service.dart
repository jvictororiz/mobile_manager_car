import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_manager_car/domain/model/metric_user.dart';
import 'package:week_of_year/week_of_year.dart';

import '../../../core/exception/exceptions.dart';

class MetricFirebaseService {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;

  final String TABLE_METRIC = "TABLE_METRIC";
  final String GENERAL = "GENERAL";

  MetricFirebaseService(this.firebaseAuth, this.firebaseDatabase);

  Future<Either<DefaultException, MetricUser?>> getGeneralMetricByWeek(int year, int weekYear) async {
    try {
      var idMetric = "${year}_$weekYear";
      String id = firebaseAuth.currentUser?.uid ?? "";
      var result = await firebaseDatabase.ref(id).child(TABLE_METRIC).child(GENERAL).child(idMetric).get().timeout(Duration(seconds: 10));
      try {
        return Right(MetricUser.fromSnapshot(result.value as Map<dynamic, dynamic>));
      } catch (ex) {
        return const Right(null);
      }
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar as métricas"));
    }
  }

  Future<Either<DefaultException, MetricUser?>> getCarMetricByWeek(String idCar, int year, int weekYear) async {
    try {
      var idMetric = "${year}_$weekYear";
      String id = firebaseAuth.currentUser?.uid ?? "";
      var result = await firebaseDatabase.ref(id).child(TABLE_METRIC).child(idCar).child(idMetric).get().timeout(Duration(seconds: 10));
      try {
        return Right(MetricUser.fromSnapshot(result.value as Map<dynamic, dynamic>));
      } catch (ex) {
        return const Right(null);
      }
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar as métricas do veículo"));
    }
  }

  Future<Either<DefaultException, Object?>> saveMetric(String idCar, bool isDebit, FinancialMovement financialMovement) async {
    var dateTime = financialMovement.dateTime;
    var idMetric = "${dateTime.year}_${dateTime.weekOfYear}";
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var resultMetricsGeneral = await getGeneralMetricByWeek(dateTime.year, dateTime.weekOfYear);
      var resultMetricsCar = await getCarMetricByWeek(idCar, dateTime.year, dateTime.weekOfYear);
      if (resultMetricsCar.isLeft || resultMetricsGeneral.isLeft) {
        return Left(DefaultException("Erro ao buscar as métricas do veículo"));
      }
      var metricGeneral = resultMetricsGeneral.right ?? MetricUser([], []);
      var metricCar = resultMetricsCar.right ?? MetricUser([], []);

      if (isDebit) {
        metricGeneral.debits.add(financialMovement);
        metricCar.debits.add(financialMovement);
      } else {
        metricGeneral.profit.add(financialMovement);
        metricCar.profit.add(financialMovement);
      }
      await firebaseDatabase.ref(id).child(TABLE_METRIC).child(GENERAL).child(idMetric).set(metricGeneral.toJson()).timeout(Duration(seconds: 10));
      await firebaseDatabase.ref(id).child(TABLE_METRIC).child(idCar).child(idMetric).set(metricCar.toJson()).timeout(Duration(seconds: 10));
      return const Right(null);
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao salvar as métricas do veículo"));
    }
  }
}
