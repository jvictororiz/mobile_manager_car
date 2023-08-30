import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/exception/exceptions.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/car.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';
import 'package:mobile_manager_car/domain/model/metric_user.dart';
import 'package:mobile_manager_car/domain/usecase/car_usecase.dart';
import 'package:mobile_manager_car/domain/usecase/metric_usecase.dart';
import 'package:mobile_manager_car/domain/usecase/reminder_usecase.dart';
import 'package:mobile_manager_car/presentation/pages/timelineCar/event/add_timeline_event.dart';
import 'package:mobile_manager_car/presentation/pages/timelineCar/state/add_timeline_state.dart';

import '../../../../domain/model/historic_oil.dart';
import '../../../../domain/model/historic_rent.dart';
import '../../../../domain/usecase/historic_usecase.dart';
import '../../../component/single_value_notifier.dart';
import '../component/model/historic_header_model.dart';
import '../event/add_timeline_event.dart';
import '../state/timeline_state.dart';

class AddTimelineController {
  final CarUseCase _carUseCase;
  final HistoricUseCase _historicUseCase;
  final MetricUseCase _metricUseCase;
  final ReminderUseCase _reminderUseCase;

  AddTimelineController(this._carUseCase, this._historicUseCase, this._metricUseCase, this._reminderUseCase);

  SingleValueNotifier action = SingleValueNotifier(AddTimelineEvent());
  ValueNotifier<AddTimelineState> state = ValueNotifier(AddTimelineState());

  void init(Car car) {
    var currentDate = DateTime.now();
    var hasContract = car.historicRent.isNotEmpty;
    state.value.car = car;
    final List<HistoricHeaderModel> tabHeaders = [
      HistoricHeaderModel('Troca de óleo', ChangedOil(HistoricOil(0, 0, currentDate), car)),
      HistoricHeaderModel('Em manutenção', CarInMaintenance("", car, currentDate)),
      HistoricHeaderModel('Atualização de kilometragem', RegisterKM(0, currentDate, car)),
      HistoricHeaderModel('Retorno manutenção', ReturnMaintenance("", car, currentDate, car.valueDefaultRent)),
      HistoricHeaderModel('Registrar débito', PrejudiceCar(0, car, currentDate, "")),
    ];

    if (hasContract) {
      tabHeaders.insert(1, HistoricHeaderModel('Pagamento do motorista', PaymentCar(car.historicRent.last, currentDate)));
    }
    state.value.listHistory = tabHeaders;
    state.value.currentHistoricType = tabHeaders.first.historicType;
    _notifyState();
  }

  void tapOnUpdateHistoric(HistoricType historic) async {
    var car = state.value.car;
    state.value.isLoading = true;
    _notifyState();

    if (historic is ChangedOil) {
      await _historicUseCase.saveHistoric(car.id, historic);
      _eventChangedOil(historic);
    } else if (historic is CarInMaintenance) {
      await _historicUseCase.saveHistoric(car.id, historic);
      _eventCarImMaintenance(historic);
    } else if (historic is PrejudiceCar) {
      await _historicUseCase.saveHistoric(car.id, historic);
      _eventPrejudiceCar(historic);
    } else if (historic is ReturnMaintenance) {
      await _historicUseCase.saveHistoric(car.id, historic);
      _eventReturnMaintenance(historic);
    } else if (historic is PaymentCar) {
      await _historicUseCase.saveHistoric(car.id, historic);
      _eventPaymentCar(historic);
    } else if (historic is RegisterKM) {
      await _historicUseCase.saveHistoric(car.id, historic);
      _eventRegisterKm(historic);
    }
  }

  void onChangeHistoryType(HistoricType historyType) {
    state.value.currentHistoricType = historyType;
    _notifyState();
  }

  void _eventChangedOil(ChangedOil historic) async {
    var car = state.value.car;
    car.historicOil.add(historic.historicOil);
    car.km = historic.historicOil.currentKm;
    state.value.isLoading = true;
    _notifyState();
    bool successMetric = false;
    bool successUpdateCar = false;
    bool successReminder = false;

    _carUseCase.registerOrUpdateCar(car, []).either(
      (error) => _error(error),
      (result) {
        successUpdateCar = true;
        _success([successMetric, successUpdateCar, successReminder]);
      },
    );

    _metricUseCase
        .saveMetric(
            car.id,
            true,
            FinancialMovement(
              dateTime: historic.historicOil.currentDate,
              description: "Troca de óleo",
              value: historic.historicOil.value,
            ))
        .either(
      (error) => _error(error),
      (result) {
        successMetric = true;
        _success([successMetric, successUpdateCar, successReminder]);
      },
    );
  }

  void _eventCarImMaintenance(CarInMaintenance carInMaintenance) {
    var car = state.value.car;
    car.inMaintenance = true;
    bool successUpdateCar = false;

    _carUseCase.registerOrUpdateCar(car, []).either(
      (error) => _error(error),
      (result) {
        successUpdateCar = true;
        _success([successUpdateCar]);
      },
    );
  }

  void _eventPrejudiceCar(PrejudiceCar historic) {
    var car = state.value.car;
    bool successMetric = false;

    _metricUseCase.saveMetric(car.id, true, FinancialMovement(dateTime: historic.date, description: historic.observation, value: historic.prejudice)).either(
      (error) => _error(error),
      (result) {
        successMetric = true;
        _success([successMetric]);
      },
    );
  }

  void _eventReturnMaintenance(ReturnMaintenance historic) {
    var car = state.value.car;
    car.inMaintenance = false;

    bool successUpdateCar = false;
    bool successMetric = false;

    _carUseCase.registerOrUpdateCar(car, []).either(
      (error) => _error(error),
      (result) {
        successUpdateCar = true;
        _success([successUpdateCar]);
      },
    );

    _metricUseCase.saveMetric(car.id, true, FinancialMovement(dateTime: historic.date, description: historic.motive, value: historic.value)).either(
      (error) => _error(error),
      (result) {
        successMetric = true;
        _success([successMetric]);
      },
    );
  }

  void _eventPaymentCar(PaymentCar historic) {
    var car = state.value.car;
    car.historicRent.add(historic.historicRent);

    bool successMetric = false;
    bool successUpdateCar = false;
    bool successReminder = false;

    _carUseCase.registerOrUpdateCar(car, []).either(
      (error) => _error(error),
      (result) {
        successUpdateCar = true;
        _success([successMetric, successUpdateCar, successReminder]);
      },
    );

    _metricUseCase.saveMetric(car.id, false, FinancialMovement(dateTime: historic.dateTime, description: "Pagamento semanal", value: historic.historicRent.valueRent)).either(
      (error) => _error(error),
      (result) {
        successMetric = true;
        _success([successMetric, successUpdateCar, successReminder]);
      },
    );

    _reminderUseCase.incrementValueCar(car.id, historic.date, historic.historicRent.valueRent).either(
      (error) => _error(error),
      (result) {
        successReminder = true;
        _success([successMetric, successUpdateCar, successReminder]);
      },
    );
  }

  void _eventRegisterKm(RegisterKM historic) {
    var car = state.value.car;
    car.km = historic.newKm;
    bool successUpdateCar = false;

    _carUseCase.registerOrUpdateCar(car, []).either(
      (error) => _error(error),
      (result) {
        successUpdateCar = true;
        _success([successUpdateCar]);
      },
    );
  }

  _error(DefaultException error) {
    state.value.isLoading = false;
    _notifyState();
    action.value = ShowNegativeMessage(error.message);
  }

  void _success(List<bool> events) {
    var allSuccess = events.all((item) => item);
    if (allSuccess) {
      action.value = ShowPositiveMessage("Evento registrado com sucesso!");
      action.value = FinishScreen();
    }
  }

  void _notifyState() {
    state.value = AddTimelineState.copy(state.value);
  }
}
