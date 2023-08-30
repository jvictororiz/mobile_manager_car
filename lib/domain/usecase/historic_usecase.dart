import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/data/repository/historic_repository.dart';
import 'package:mobile_manager_car/domain/model/driver.dart';

import '../../core/exception/exceptions.dart';
import '../../data/repository/driver_repository.dart';
import '../model/historic_type.dart';

class HistoricUseCase {
  final HistoricRepository _historicRepository;

  HistoricUseCase(this._historicRepository);

  Future<Either<DefaultException,  List<HistoricType>>> getAllHistoric(int? limit) {
    return _historicRepository.getAllHistoric(limit);
  }

  Future<Either<DefaultException, List<HistoricType>>> getAllHistoricByCar(String idCar) async {
    return _historicRepository.getAllHistoricByCar(idCar);
  }

  Future saveHistoric(String idCar, HistoricType historicType) async {
    return _historicRepository.saveHistoric(idCar, historicType);
  }
}
