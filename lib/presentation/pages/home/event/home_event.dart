


class HomeEvent {}

class ShowNegativeMessage extends HomeEvent {
  final String message;
  ShowNegativeMessage(this.message);
}
class ShowPositiveMessage extends HomeEvent {
  final String message;
  ShowPositiveMessage(this.message);
}