import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/reminder_check.dart';
import 'package:week_of_year/week_of_year.dart';

import '../../../core/exception/exceptions.dart';
import '../../../domain/model/car.dart';

class ReminderFirebaseService {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;

  final String TABLE_REMINDER = "TABLE_REMINDER";

  ReminderFirebaseService(this.firebaseAuth, this.firebaseDatabase);

  Future<Either<DefaultException, List<ReminderCheck?>>> getAllReminderCars(int year, int weekYear, List<Car> cars) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var idReminder = "${year}_$weekYear";
      var result = await firebaseDatabase.ref(id).child(TABLE_REMINDER).child(idReminder).get().timeout(Duration(seconds: 10));
      var listReminderCheck = result.children.map((item) {
        var map = item.value as Map<dynamic, dynamic>;
        print(map);
        return ReminderCheck.fromSnapshot(map);
      }).toList(growable: true);
      print(listReminderCheck);
      return Right(listReminderCheck);
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar os avisos, verifique a sua conexão."));
    }
  }

  Future<Either<DefaultException, Object?>> incrementValueCar(String idCar, DateTime dateTime, double value) async {
    var idReminder = "${dateTime.year}_${dateTime.weekOfYear}";
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var resultReminders = await _getRemindersByCar(idCar, dateTime);
      if (resultReminders.isLeft) {
        return Left(DefaultException("Erro ao atualizar as notificações"));
      }
      var reminder = resultReminders.right;
      if (reminder == null) {
        reminder = ReminderCheck(idCar, value);
      } else {
        reminder.value = reminder.value + value;
      }

      await firebaseDatabase.ref(id).child(TABLE_REMINDER).child(idReminder).child(idCar).set(reminder.toJson()).timeout(Duration(seconds: 10));
      return const Right(null);
    } catch (e) {
      return Left(DefaultException("Erro ao atualizar as notificações"));
    }
  }

  Future<Either<DefaultException, ReminderCheck?>> _getRemindersByCar(String idCar, DateTime dateTime) async {
    try {
      var year = dateTime.year;
      var weekYear = dateTime.weekOfYear;
      var idReminder = "${year}_$weekYear";
      String id = firebaseAuth.currentUser?.uid ?? "";
      var result = await firebaseDatabase.ref(id).child(TABLE_REMINDER).child(idReminder).child(idCar).get().timeout(Duration(seconds: 10));
      try {
        print(result.value);
        var reminder = ReminderCheck.fromSnapshot(result.value as Map<dynamic, dynamic>);
        return Right(reminder);
      } catch (exception) {
        return const Right(null);
      }
    } catch (e) {
      return Left(DefaultException("Erro ao buscar alertas"));
    }
  }
}
