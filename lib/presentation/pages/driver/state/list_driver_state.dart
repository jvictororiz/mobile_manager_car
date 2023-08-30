import '../../../../domain/model/driver.dart';

class ListDriverState {
  bool isLoading = true;
  bool isEmpty = false;
  bool showError = false;
  bool showSuccess = false;
  List<Driver> drivers = List.empty(growable: true);

  ListDriverState.copy(ListDriverState driverState) {
    isLoading = driverState.isLoading;
    isEmpty = driverState.isEmpty;
    drivers = driverState.drivers;
    showSuccess = driverState.showSuccess;
    showError = driverState.showError;
  }


  ListDriverState.showError() {
    isLoading = false;
    isEmpty = false;
    showError = true;
    showSuccess = false;
  }

  ListDriverState.success(this.drivers) {
    isLoading = false;
    isEmpty = drivers.isEmpty;
    showError = false;
    showSuccess = true;
  }

  ListDriverState({this.isLoading = true, this.isEmpty = false, this.showSuccess = false, this.showError = false});
}
