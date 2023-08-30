class ProfileState {
  String nameUser = "";
  String emailUser = "";

  ProfileState(this.nameUser, this.emailUser);

  ProfileState.copy(ProfileState profileState) {
    nameUser = profileState.nameUser;
    emailUser = profileState.emailUser;
  }
}
