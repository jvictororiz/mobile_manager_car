class LoginState {
  bool isLoading = false;
  bool showBiometric = true;

  LoginState.copy(LoginState homeState) {
    isLoading = homeState.isLoading;
    showBiometric = homeState.showBiometric;
  }

  LoginState({
    this.isLoading = false,
    this.showBiometric = true,
  });
}
