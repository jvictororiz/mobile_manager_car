import 'dart:ffi';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/domain/model/driver.dart';

import '../../core/exception/exceptions.dart';
import '../../domain/model/car.dart';
import '../../domain/model/car_driver.dart';
import '../datasource/firebase/car_firebase_service.dart';

class CarRepository {
  final CarFirebaseService _carFirebaseService;

  CarRepository(this._carFirebaseService);

  Future<Either<DefaultException, List<Car>>> getAllCars() {
    return _carFirebaseService.getAllCars();
  }

  Future<Either<DefaultException, List<Car>>> getCarsByLimit(int limit) {
    return _carFirebaseService.getCarsByLimit(limit);
  }

  Future<Either<DefaultException, Car>> registerOrUpdateCar(Car car, List<File> newImages) async {
    return _carFirebaseService.registerOrUpdateCar(car, newImages);
  }

  Future<Either<DefaultException, Car>> deleteImage(Car car, String idImage) async {
    return _carFirebaseService.deleteImage(car, idImage);
  }

  Future<Either<DefaultException, Car>> linkDriver(Car car, Driver driver, int? dayWeekPayment, double? valueRent) {
    return _carFirebaseService.linkDriver(car, driver, dayWeekPayment, valueRent);
  }

  Future<Either<DefaultException, Car>> unlinkDriver(Car car,CarDriver carDriver) {
    return _carFirebaseService.unlinkDriver(car, carDriver);
  }

  Future<Either<DefaultException, Car>> getCarById(String idCar) {
    return _carFirebaseService.getCarById(idCar);
  }
}
