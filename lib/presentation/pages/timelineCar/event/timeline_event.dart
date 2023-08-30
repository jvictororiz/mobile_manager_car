class TimelineEvent {}

class ShowNegativeMessage extends TimelineEvent {
  final String message;
  ShowNegativeMessage(this.message);
}
class ShowPositiveMessage extends TimelineEvent {
  final String message;
  ShowPositiveMessage(this.message);
}