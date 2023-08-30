
class RegisterCarEvent {}

class FinishScreen extends RegisterCarEvent {}
class ShowNegativeMessage extends RegisterCarEvent {
  final String message;
  ShowNegativeMessage(this.message);
}
class ShowPositiveMessage extends RegisterCarEvent {
  final String message;
  ShowPositiveMessage(this.message);
}