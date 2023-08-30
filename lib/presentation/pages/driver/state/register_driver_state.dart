import 'package:mobile_manager_car/domain/model/driver.dart';

class RegisterDriverState {
  bool isLoading = false;
  String titleToolbar = "";
  Driver? driver;

  RegisterDriverState.copy(RegisterDriverState homeState) {
    isLoading = homeState.isLoading;
    driver = homeState.driver;
    titleToolbar = homeState.titleToolbar;
  }

  RegisterDriverState({this.isLoading = false});
}
