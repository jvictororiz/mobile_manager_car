import 'dart:ffi';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/domain/model/driver.dart';

import '../../core/exception/exceptions.dart';
import '../../domain/model/car.dart';
import '../datasource/firebase/car_firebase_service.dart';
import '../datasource/firebase/driver_firebase_service.dart';

class DriverRepository {
  final DriverFirebaseService _driverFirebaseService;

  DriverRepository(this._driverFirebaseService);

  Future<Either<DefaultException,  List<Driver>>> getAllDrivers() {
    return _driverFirebaseService.getAllDrivers();
  }

  Future<Either<DefaultException, Driver>> registerOrUpdateCar(Driver driver, List<File> newImages) async {
    return _driverFirebaseService.registerOrUpdateDriver(driver, newImages);
  }

  Future<Either<DefaultException, Driver>> deleteImage(Driver driver, String idImage) async {
    return _driverFirebaseService.deleteImage(driver, idImage);
  }

  Future<Either<DefaultException, Driver>> getDriverById(String idDriver) {
    return _driverFirebaseService.getDriverById(idDriver);
  }
}
