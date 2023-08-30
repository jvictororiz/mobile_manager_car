import '../../../../domain/model/car.dart';
import '../../../../domain/model/historic_type.dart';

class TimelineState {
  late Car? car;
  String titlePage = "";
  bool isSuccess = false;
  bool isLoading = false;
  bool isEmpty = false;
  bool isError = false;
  bool showButtonAdd = false;
  List<HistoricType> histories = List.empty(growable: true);

  TimelineState({this.titlePage = "",this.isLoading = false, this.isEmpty = false, this.isError = false, this.isSuccess = false, this.showButtonAdd = false});

  TimelineState.copy(TimelineState state) {
    car = state.car;
    isSuccess = state.isSuccess;
    isLoading = state.isLoading;
    isEmpty = state.isEmpty;
    isError = state.isError;
    titlePage = state.titlePage;
    histories = state.histories;
    showButtonAdd = state.showButtonAdd;
  }
}
