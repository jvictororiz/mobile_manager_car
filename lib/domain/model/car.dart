import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:week_of_year/week_of_year.dart';

import 'historic_oil.dart';
import 'car_driver.dart';
import 'historic_rent.dart';

class Car {
  String id;
  String model;
  String year;
  double km;
  double valueDefaultRent;
  String plate;
  double maxKm;
  bool inMaintenance;
  CarDriver? carDriver;
  List<HistoricRent> historicRent = [];
  List<HistoricOil> historicOil = [];
  List<String> images = [];

  Car({this.id = "",
    required this.model,
    required this.year,
    required this.km,
    required this.plate,
    required this.maxKm,
    required this.carDriver,
    required this.images,
    required this.valueDefaultRent,
    required this.inMaintenance,
    required this.historicOil,
    required this.historicRent});

  Car.empty({this.id = "", this.model = "", this.year = "", this.km = 0, this.plate = "", this.maxKm = 0, this.carDriver, this.valueDefaultRent = 0, this.inMaintenance = false});

  factory Car.fromSnapshot(Map<dynamic, dynamic> data) {
    List<Map<dynamic, dynamic>> mapHistoricOil = (data['historicOil'] ?? []).cast<Map<dynamic, dynamic>>();
    List<Map<dynamic, dynamic>> mapHistoricRent = (data['historicRent'] ?? []).cast<Map<dynamic, dynamic>>();
    return Car(
      id: data['id'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? '',
      inMaintenance: data['inMaintenance'] ?? false,
      km: (data['km'] ?? 0).toDouble(),
      valueDefaultRent: (data['valueDefaultRent'] ?? 0).toDouble(),
      plate: data['plate'] ?? '',
      maxKm: (data['maxKm'] ?? 0).toDouble(),
      images: (data['images'] ?? []).cast<String>(),
      historicOil: mapHistoricOil.map((item) => HistoricOil.fromSnapshot(item)).toList(growable: true),
      historicRent: mapHistoricRent.map((item) => HistoricRent.fromSnapshot(item)).toList(growable: true),
      carDriver: data['carDriver'] != null ? CarDriver.fromMap(data['carDriver'] as Map<dynamic, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> historicOilList = historicOil.map((item) => item.toJson()).toList(growable: true);
    List<Map<String, dynamic>> historicRentList = historicRent.map((item) => item.toJson()).toList(growable: true);
    return {
      'id': id,
      'model': model,
      'year': year,
      'km': km,
      'valueDefaultRent': valueDefaultRent,
      'inMaintenance': inMaintenance,
      'plate': plate,
      'maxKm': maxKm,
      'carDriver': carDriver?.toJson(),
      'historicOil': historicOilList,
      'historicRent': historicRentList,
      'images': images,
    };
  }

  bool isMaxKM(int year, int weekYear) {
    var currentHistoric = historicOil.find((item) {
      var currentYear = item.currentDate.year;
      var currentWeekYear = item.currentDate.weekOfYear;
      return year == currentYear && currentWeekYear == weekYear;
    });
    if (currentHistoric == null) {
      return km >= maxKm;
    }else{
      return false;
    }
  }

  String getName() {
    return "$model $year";
  }

  String getNameAndPlate() {
    return "$model ($plate)";
  }
}
