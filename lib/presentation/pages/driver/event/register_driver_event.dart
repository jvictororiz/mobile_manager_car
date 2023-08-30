
class RegisterDriverEvent {}

class FinishScreen extends RegisterDriverEvent {}
class ShowNegativeMessage extends RegisterDriverEvent {
  final String message;
  ShowNegativeMessage(this.message);
}
class ShowPositiveMessage extends RegisterDriverEvent {
  final String message;
  ShowPositiveMessage(this.message);
}