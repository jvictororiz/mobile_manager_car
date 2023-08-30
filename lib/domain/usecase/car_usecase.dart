import 'dart:ffi';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/domain/model/driver.dart';

import '../../core/exception/exceptions.dart';
import '../../data/repository/car_repository.dart';
import '../../presentation/res/strings.dart';
import '../model/car.dart';
import '../model/car_driver.dart';

class CarUseCase {
  final CarRepository _carRepository;

  CarUseCase(this._carRepository);

  Future<Either<DefaultException, List<Car>>> getAllCars() async {
    return _carRepository.getAllCars();
  }

  Future<Either<DefaultException, List<Car>>> getCarsByLimit(int limit) {
    return _carRepository.getCarsByLimit(limit);
  }

  Future<Either<DefaultException, Car>> linkDriver(Car car, Driver driver, int? dayWeekPayment, double? valueRent) async {
    return _carRepository.linkDriver(car, driver,dayWeekPayment,valueRent);
  }

  Future<Either<DefaultException, Car>> unLinkDriver(Car car, CarDriver carDriver) async {
    return _carRepository.unlinkDriver(car, carDriver);
  }

  Future<Either<DefaultException, Car>> deleteImage(Car car, String idImage) async {
     return _carRepository.deleteImage(car, idImage);
  }

  Future<Either<DefaultException, Car>> registerOrUpdateCar(Car car, List<File> newImages) async {
    if(car.plate.isEmpty){
      return Left(DefaultException("Campo `${Strings.plate}` é obrigatório"));
    }
    if(car.maxKm == 0){
      return Left(DefaultException("Campo `${Strings.maxKm}` é obrigatório"));
    }
    if(car.model.isEmpty){
      return Left(DefaultException("Campo `${Strings.model}` é obrigatório"));
    }
    if(car.year.isEmpty){
      return Left(DefaultException("Campo `${Strings.year}` é obrigatório"));
    }
    if(car.valueDefaultRent == 0) {
      return Left(DefaultException("Campo `${Strings.valueDefault}` é obrigatório"));
    }

    return _carRepository.registerOrUpdateCar(car, newImages);
  }

  Future<Either<DefaultException, Car>> getCarById(String idCar) async {
    return _carRepository.getCarById(idCar);
  }
}
