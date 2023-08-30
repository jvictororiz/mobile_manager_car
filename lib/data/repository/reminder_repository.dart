import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/data/datasource/firebase/reminder_firebase_service.dart';

import '../../core/exception/exceptions.dart';
import '../../domain/model/car.dart';
import '../../domain/model/reminder_check.dart';

class ReminderRepository{
  final ReminderFirebaseService _reminderFirebaseService;

  ReminderRepository(this._reminderFirebaseService);

  Future<Either<DefaultException, Object?>> incrementValueCar(String idCar, DateTime dateTime, double value) async {
    return _reminderFirebaseService.incrementValueCar(idCar, dateTime, value);
  }

  Future<Either<DefaultException, List<ReminderCheck?>>> getAllReminderCars(int year, int weekYear, List<Car> cars) async {
    return _reminderFirebaseService.getAllReminderCars(year, weekYear, cars);
  }
}