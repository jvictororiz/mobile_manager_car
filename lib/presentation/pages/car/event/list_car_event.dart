
import '../../../../domain/model/car.dart';
import '../../../../domain/model/driver.dart';

class ListCarEvent {}

class ShowNegativeMessage extends ListCarEvent {
  final String message;
  ShowNegativeMessage(this.message);
}
class ShowPositiveMessage extends ListCarEvent {
  final String message;
  ShowPositiveMessage(this.message);
}

class ChangeStatusDriversModal extends ListCarEvent {
  List<Driver> drivers = List.empty(growable: true);
  final bool isSuccess;
  final  bool isLoading;
  final  bool isError;
  final  bool isEmpty;

  ChangeStatusDriversModal(this.drivers, {this.isSuccess = false, this.isLoading = false, this.isError = false, this.isEmpty = false});
}

class OpenDriversModal extends ListCarEvent {
  final Car car;
  OpenDriversModal(this.car);
}

class OpenEditDriver extends ListCarEvent {
  final Driver driver;
  OpenEditDriver(this.driver);
}