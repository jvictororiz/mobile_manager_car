
class LoginEvent {}

class GoToHome extends LoginEvent {}

class ShowNegativeMessage extends LoginEvent {
  final String message;
  ShowNegativeMessage(this.message);
}