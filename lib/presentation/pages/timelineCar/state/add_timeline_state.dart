import '../../../../domain/model/car.dart';
import '../../../../domain/model/historic_type.dart';
import '../component/model/historic_header_model.dart';

class AddTimelineState {
  late Car car;
  bool isLoading = false;
  List<HistoricHeaderModel> listHistory = [];
  late HistoricType currentHistoricType;

  AddTimelineState({isLoading = false});

  AddTimelineState.copy(AddTimelineState state) {
    car = state.car;
    isLoading = state.isLoading;
    listHistory = state.listHistory;
    currentHistoricType = state.currentHistoricType;
  }
}
