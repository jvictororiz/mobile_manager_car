import '../../../../domain/model/car.dart';

class RegisterCarState {
  bool isLoading = false;
  String titleToolbar = "";
  Car? car;
  bool editKmEnable = true;

  RegisterCarState.copy(RegisterCarState homeState) {
    isLoading = homeState.isLoading;
    car = homeState.car;
    editKmEnable = homeState.editKmEnable;
    titleToolbar = homeState.titleToolbar;
  }

  RegisterCarState({this.isLoading = false});
}
