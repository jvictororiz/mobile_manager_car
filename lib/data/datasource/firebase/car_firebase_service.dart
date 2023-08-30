import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_manager_car/domain/model/car_driver.dart';
import 'package:mobile_manager_car/domain/model/driver.dart';
import 'package:mobile_manager_car/domain/model/historic_rent.dart';

import '../../../core/exception/exceptions.dart';
import '../../../domain/model/car.dart';
import 'driver_firebase_service.dart';

class CarFirebaseService {
  final FirebaseAuth firebaseAuth;
  final DriverFirebaseService driverFirebaseService;
  final FirebaseDatabase firebaseDatabase;
  final FirebaseStorage firebaseStorage;

  final String TABLE_CARS = "TABLE_CARS";

  CarFirebaseService(this.firebaseAuth, this.firebaseDatabase, this.firebaseStorage, this.driverFirebaseService);

  Future<Either<DefaultException, Car>> getCarById(String idCar) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var result = await firebaseDatabase.ref(id).child(TABLE_CARS).child(idCar).get().timeout(Duration(seconds: 10));
      var car = Car.fromSnapshot(result.value as Map<dynamic, dynamic>);
      return Right(car);
    } catch (e) {
      return Left(DefaultException("Erro ao buscar o veículo, verifique a sua conexão."));
    }
  }

  Future<Either<DefaultException, List<Car>>> getAllCars() async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var result = await firebaseDatabase.ref(id).child(TABLE_CARS).get().timeout(Duration(seconds: 10));
      var listCars = result.children.map((item) {
        return Car.fromSnapshot(item.value as Map<dynamic, dynamic>);
      }).toList(growable: true);
      return Right(listCars);
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar os veículos, verifique a sua conexão."));
    }
  }

  Future<Either<DefaultException, List<Car>>> getCarsByLimit(int limit) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var result = await firebaseDatabase.ref(id).child(TABLE_CARS).limitToFirst(5).get().timeout(Duration(seconds: 10));
      var listCars = result.children.map((item) {
        return Car.fromSnapshot(item.value as Map<dynamic, dynamic>);
      }).toList(growable: true);
      return Right(listCars);
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar os veículos, verifique a sua conexão."));
    }
  }

  Future<Either<DefaultException, Car>> deleteImage(Car car, String idImage) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      await firebaseStorage.ref(id).child(TABLE_CARS).child(car.id).child(idImage).delete();
      int indexDeleted = car.images.indexWhere((element) => element.contains(id));
      var images = car.images.toList(growable: true);
      images.removeAt(indexDeleted);
      car.images = images;
      return registerOrUpdateCar(car, []);
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar os veículos, verifique a sua conexão."));
    }
  }

  Future<Either<DefaultException, Car>> registerOrUpdateCar(Car car, List<File> newImages) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var tableCar = firebaseDatabase.ref(id).child(TABLE_CARS);
      if (car.id.isEmpty) {
        var id = tableCar.push().key ?? "";
        car.id = id;
      }
      for (var element in newImages) {
        String idImage = DateTime.now().millisecondsSinceEpoch.toString();
        TaskSnapshot taskSnapshot = await firebaseStorage.ref(id).child(TABLE_CARS).child(car.id).child(idImage).putFile(element);
        String url = await taskSnapshot.ref.getDownloadURL();
        List<String> allImages = [];
        allImages.addAll(car.images);
        allImages.add(url);
        car.images = allImages;
      }
      tableCar.child(car.id).set(car.toJson());
      return Right(car);
    } catch (e) {
      print(e);
      return Left(DefaultException("Não foi possível realizar o cadastro do veículo, por favor, tente novamente mais tarde"));
    }
  }

  Future<Either<DefaultException, Car>> linkDriver(Car car, Driver driver, int? dayWeekPayment, double? valueRent) async {
    driver.idCar = car.id;
    var resultDriver = await driverFirebaseService.registerOrUpdateDriver(driver, []);
    if (resultDriver.isLeft) {
      return Left(DefaultException("Houve um erro ao adicionar o motorista, por favor, tente novamente mais tarde"));
    }
    car.historicRent.add(HistoricRent(driverName: driver.name, carName: car.getNameAndPlate(), dateInit: DateTime.now(), valueRent: valueRent ?? car.valueDefaultRent));
    car.carDriver = CarDriver(name: driver.name, cpf: driver.cpf, urlImage: driver.getFirstImage(), id: driver.id, dayWeekPayment: dayWeekPayment!, valueRent: valueRent!);
    return registerOrUpdateCar(car, []);
  }

  Future<Either<DefaultException, Car>> unlinkDriver(Car car, CarDriver carDriver) async {
    var driverResult = await driverFirebaseService.getDriverById(carDriver.id);
    if (driverResult.isLeft) {
      return Left(DefaultException("Houve um erro ao desvincular o motorista, por favor, tente novamente mais tarde"));
    }
    var driver = driverResult.right;
    driver.idCar = null;
    car.carDriver = null;
    car.historicRent.last.dateFinish = DateTime.now();
    var result = await driverFirebaseService.registerOrUpdateDriver(driver, []);
    if (result.isLeft) {
      return Left(DefaultException("Houve um erro ao desvincular o motorista, por favor, tente novamente mais tarde"));
    }
    return registerOrUpdateCar(car, []);
  }
}
