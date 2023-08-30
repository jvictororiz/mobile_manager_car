class RegisterState {
  bool isLoading = false;

  RegisterState.copy(RegisterState homeState) {
    isLoading = homeState.isLoading;
  }

  RegisterState({this.isLoading = false});
}
