import '../../../../domain/model/car.dart';
import '../../../../domain/model/driver.dart';

class ListCarState {
  bool isLoading = true;
  bool isEmpty = false;
  bool showError = false;
  bool showSuccess = false;
  double percentRunning = 0;
  int carsRunning = 0;
  int carsInMaintenance = 0;
  int carsAvailable = 0;
  List<Car> cars = List.empty(growable: true);

  ListCarState.copy(ListCarState homeState) {
    isLoading = homeState.isLoading;
    isEmpty = homeState.isEmpty;
    cars = homeState.cars;
    showSuccess = homeState.showSuccess;
    showError = homeState.showError;
    carsRunning = homeState.carsRunning;
    carsInMaintenance = homeState.carsInMaintenance;
    carsAvailable = homeState.carsAvailable;
    percentRunning = homeState.percentRunning;
  }

  ListCarState.showError() {
    isLoading = false;
    isEmpty = false;
    showError = true;
    showSuccess = false;
  }

  ListCarState.success(this.cars) {
    isLoading = false;
    isEmpty = cars.isEmpty;
    showError = false;
    showSuccess = true;
  }

  ListCarState({this.isLoading = true, this.isEmpty = false, this.showSuccess = false, this.showError = false});
}
