
class ListDriverEvent {}

class ShowNegativeMessage extends ListDriverEvent {
  final String message;
  ShowNegativeMessage(this.message);
}
class ShowPositiveMessage extends ListDriverEvent {
  final String message;
  ShowPositiveMessage(this.message);
}