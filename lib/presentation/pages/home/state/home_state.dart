import 'package:mobile_manager_car/domain/model/historic_type.dart';
import '../../../../domain/model/car.dart';

class HomeCarState {
  bool isSuccess = false;
  bool isLoading = false;
  bool isEmpty = false;
  bool isError = false;
  List<Car> cars = List.empty(growable: true);

  HomeCarState(this.isLoading, this.isEmpty, this.isError, this.isSuccess, this.cars);
}

class HomeHistoryState {
  bool isSuccess = false;
  bool isLoading = false;
  bool isEmpty = false;
  bool isError = false;
  List<HistoricType> histories = List.empty(growable: true);

  HomeHistoryState(this.isLoading, this.isEmpty, this.isError, this.isSuccess, this.histories);
}

class HomeReminderState {
  bool isSuccess = false;
  bool isLoading = false;
  bool isEmpty = false;
  bool isError = false;
  List<String> reminders = List.empty(growable: true);

  HomeReminderState(this.isLoading, this.isEmpty, this.isError, this.isSuccess, this.reminders);
}

class HomeMetricsState {
  bool isSuccess = false;
  bool isLoading = false;
  bool isEmpty = false;
  bool isError = false;
  double negativeValue = 0;
  double positiveValue = 0;

  HomeMetricsState(this.isLoading, this.isEmpty, this.isError, this.isSuccess, this.negativeValue, this.positiveValue);
}


class HomeState {
  HomeCarState homeCarState = HomeCarState(false, false, false, false, []);
  HomeHistoryState homeHistoryState = HomeHistoryState(false, false, false, false, []);
  HomeReminderState homeReminderState = HomeReminderState(false, false, false, false, []);
  HomeMetricsState homeMetricsState = HomeMetricsState(false, false, false, false, 0,0);

  HomeState();

  HomeState.copy(HomeState homeState) {
    homeCarState = homeState.homeCarState;
    homeHistoryState = homeState.homeHistoryState;
    homeReminderState = homeState.homeReminderState;
    homeMetricsState = homeState.homeMetricsState;
  }
}
