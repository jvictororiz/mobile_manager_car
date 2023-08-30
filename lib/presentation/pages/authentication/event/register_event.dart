class RegisterEvent {}

class GoToHome extends RegisterEvent {}

class ShowNegativeMessage extends RegisterEvent {
  final String message;
  ShowNegativeMessage(this.message);
}