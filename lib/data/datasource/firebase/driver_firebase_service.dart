import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_manager_car/data/datasource/firebase/car_firebase_service.dart';
import 'package:mobile_manager_car/domain/model/driver.dart';

import '../../../core/exception/exceptions.dart';

class DriverFirebaseService {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;
  final FirebaseStorage firebaseStorage;

  final String TABLE_DRIVER = "TABLE_DRIVER";

  DriverFirebaseService(this.firebaseAuth, this.firebaseDatabase, this.firebaseStorage);

  Future<Either<DefaultException, List<Driver>>> getAllDrivers() async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var result = await firebaseDatabase.ref(id).child(TABLE_DRIVER).get().timeout(Duration(seconds: 10));
      var listDrivers = result.children.map((item) {
        return Driver.fromSnapshot(item.value as Map<dynamic, dynamic>);
      }).toList(growable: true);
      return Right(listDrivers);
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar os motoristas, verifique a sua conexão."));
    }
  }

  Future<Either<DefaultException, Driver>> deleteImage(Driver driver, String idImage) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      await firebaseStorage.ref(id).child(TABLE_DRIVER).child(driver.id).child(idImage).delete();
      int indexDeleted = driver.images.indexWhere((element) => element.contains(id));
      var images = driver.images.toList(growable: true);
      images.removeAt(indexDeleted);
      driver.images = images;
      return registerOrUpdateDriver(driver, []);
    } catch (e) {
      print(e);
      return Left(DefaultException("Erro ao buscar os motoristas, verifique a sua conexão."));
    }
  }

  Future<Either<DefaultException, Driver>> registerOrUpdateDriver(Driver driver, List<File> newImages) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var tableDriver = firebaseDatabase.ref(id).child(TABLE_DRIVER);
      if (driver.id.isEmpty) {
        var id = tableDriver.push().key ?? "";
        driver.id = id;
      }
      for (var element in newImages) {
        String idImage = DateTime.now().millisecondsSinceEpoch.toString();
        TaskSnapshot taskSnapshot = await firebaseStorage.ref(id).child(TABLE_DRIVER).child(driver.id).child(idImage).putFile(element);
        String url = await taskSnapshot.ref.getDownloadURL();
        driver.images.add(url);
      }
      tableDriver.child(driver.id).set(driver.toJson());
      return Right(driver);
    } catch (e) {
      print(e);
      return Left(DefaultException("Não foi possível realizar o cadastro do veículo, por favor, tente novamente mais tarde"));
    }
  }

  Future<Either<DefaultException, Driver>> getDriverById(String idDriver) async {
    try {
      String id = firebaseAuth.currentUser?.uid ?? "";
      var result = await firebaseDatabase.ref(id).child(TABLE_DRIVER).child(idDriver).get().timeout(Duration(seconds: 10));
      var driver =  Driver.fromSnapshot(result.value as Map<dynamic, dynamic>);
      return Right(driver);
    } catch (e) {
      return Left(DefaultException("Erro ao buscar o motorista, verifique a sua conexão."));
    }
  }
}
