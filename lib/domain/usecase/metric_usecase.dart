import 'package:either_dart/either.dart';
import 'package:mobile_manager_car/data/repository/metric_repository.dart';

import '../../core/exception/exceptions.dart';
import '../model/metric_user.dart';

class MetricUseCase{
  final MetricRepository _metricRepository;

  MetricUseCase(this._metricRepository);

  Future<Either<DefaultException, MetricUser?>> getGeneralMetricByWeek(int year, int weekYear) async {
    return _metricRepository.getGeneralMetricByWeek(year, weekYear);
  }

  Future<Either<DefaultException, MetricUser?>> getCarMetricByWeek(String idCar, int year, int weekYear) async {
    return _metricRepository.getCarMetricByWeek(idCar, year, weekYear);
  }

  Future<Either<DefaultException, Object?>> saveMetric(String idCar, bool isDebit, FinancialMovement financialMovement) async {
    return _metricRepository.saveMetric(idCar,  isDebit, financialMovement);
  }
}