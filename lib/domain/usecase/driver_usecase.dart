import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/domain/model/driver.dart';

import '../../core/exception/exceptions.dart';
import '../../data/repository/driver_repository.dart';

class DriverUseCase {
  final DriverRepository _driverRepository;

  DriverUseCase(this._driverRepository);

  Future<Either<DefaultException, List<Driver>>> getAllDrivers() async {
    return _driverRepository.getAllDrivers();
  }

  Future<Either<DefaultException, Driver>> deleteImage(Driver driver, String idImage) async {
    return _driverRepository.deleteImage(driver, idImage);
  }

  Future<Either<DefaultException, Driver>> registerOrUpdateCar(Driver driver, List<File> newImages) async {
    if (driver.name.isEmpty) {
      return Left(DefaultException("Campo `Nome` é obrigatório"));
    }
    if (driver.cpf.isEmpty) {
      return Left(DefaultException("Campo `CPF` é obrigatório"));
    }
    if (driver.phoneNumber.isEmpty) {
      return Left(DefaultException("Campo `Telefone` é obrigatório"));
    }

    return _driverRepository.registerOrUpdateCar(driver, newImages);
  }

  Future<Either<DefaultException, Driver>> getDriverById(String idDriver) {
    return _driverRepository.getDriverById(idDriver);
  }
}
