import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/data/datasource/firebase/metric_firebase_service.dart';

import '../../core/exception/exceptions.dart';
import '../../domain/model/metric_user.dart';

class MetricRepository {
  final MetricFirebaseService _metricFirebaseService;

  MetricRepository(this._metricFirebaseService);

  Future<Either<DefaultException, MetricUser?>> getGeneralMetricByWeek(int year, int weekYear) async {
    return _metricFirebaseService.getGeneralMetricByWeek(year, weekYear);
  }

  Future<Either<DefaultException, MetricUser?>> getCarMetricByWeek(String idCar, int year, int weekYear) async {
    return _metricFirebaseService.getCarMetricByWeek(idCar, year, weekYear);
  }

  Future<Either<DefaultException, Object?>> saveMetric(String idCar,  bool isDebit, FinancialMovement financialMovement) async {
    return _metricFirebaseService.saveMetric(idCar,  isDebit, financialMovement);
  }
}
