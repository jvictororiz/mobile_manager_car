class AddTimelineEvent {}

class ShowNegativeMessage extends AddTimelineEvent {
  final String message;
  ShowNegativeMessage(this.message);
}
class ShowPositiveMessage extends AddTimelineEvent {
  final String message;
  ShowPositiveMessage(this.message);
}

class FinishScreen extends AddTimelineEvent{}