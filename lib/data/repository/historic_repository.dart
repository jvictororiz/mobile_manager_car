import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/data/datasource/firebase/historic_firebase_service.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import '../../core/exception/exceptions.dart';

class HistoricRepository{
  final HistoricFirebaseService _historicFirebaseService;

  HistoricRepository(this._historicFirebaseService);

  Future<Either<DefaultException,  List<HistoricType>>> getAllHistoric(int? limit) {
    return _historicFirebaseService.getAllHistoric(limit);
  }

  Future<Either<DefaultException, List<HistoricType>>> getAllHistoricByCar(String idCar) async {
    return _historicFirebaseService.getAllHistoricByCar(idCar);
  }

  Future saveHistoric(String idCar, HistoricType historicType) async {
    return _historicFirebaseService.addHistoricCar(idCar, historicType);
  }
}