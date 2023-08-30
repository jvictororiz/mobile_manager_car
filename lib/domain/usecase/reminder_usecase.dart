import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/data/repository/reminder_repository.dart';

import '../../core/exception/exceptions.dart';
import '../model/car.dart';
import '../model/reminder_check.dart';

class ReminderUseCase{
  final ReminderRepository _reminderRepository;

  ReminderUseCase(this._reminderRepository);

  Future<Either<DefaultException, Object?>> incrementValueCar(String idCar, DateTime dateTime, double value) async {
    return _reminderRepository.incrementValueCar(idCar, dateTime, value);
  }

  Future<Either<DefaultException, List<ReminderCheck?>>> getAllReminderCars(int year, int weekYear, List<Car> cars) async {
    return _reminderRepository.getAllReminderCars(year, weekYear, cars);
  }
}