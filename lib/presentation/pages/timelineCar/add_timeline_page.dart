import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_manager_car/presentation/pages/timelineCar/component/car_in_maintenance_input.dart';
import 'package:mobile_manager_car/presentation/pages/timelineCar/component/return_maintenance_input.dart';
import 'package:mobile_manager_car/presentation/pages/timelineCar/state/add_timeline_state.dart';

import '../../../domain/model/car.dart';
import '../../../domain/model/historic_type.dart';
import '../../component/message_util.dart';
import '../../res/custom_colors.dart';
import '../timelineCar/event/add_timeline_event.dart';
import 'component/change_oil_input.dart';
import 'component/payment_car_input.dart';
import 'component/prejudice_car_input.dart';
import 'component/register_km_input.dart';
import 'component/timeline_header_items.dart';
import 'controller/add_timeline_controller.dart';

class AddTimelinePage extends StatefulWidget {
  final Car car;

  const AddTimelinePage({Key? key, required this.car}) : super(key: key);

  @override
  State<AddTimelinePage> createState() => _AddTimelinePageState();
}

class _AddTimelinePageState extends State<AddTimelinePage> {
  final AddTimelineController _controller = GetIt.I.get();
  late AddTimelineState state;

  @override
  void initState() {
    state = _controller.state.value;
    _configObservers();
    _controller.init(widget.car);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = _controller.state.value;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: CustomColors.primaryColor,
          elevation: 0,
          title: const Text("Adicionar evento"),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 100),
            child: Column(
              children: [
                const SizedBox(height: 12),
                TimelineHeaderItems(
                  tabs: state.listHistory,
                  onChange: (historyType) {
                    _controller.onChangeHistoryType(historyType);
                  },
                ),
                const Divider(color: Colors.grey),
                _getWidgetByHistoryType(state)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _configObservers() {
    _controller.state.addListener(() {
      setState(() {});
    });
    _controller.action.addListener(() async {
      var action = _controller.action.value;
      if (action is ShowNegativeMessage) {
        MessageUtil.showNegativeMessage(action.message, context);
      }
      if (action is ShowPositiveMessage) {
        MessageUtil.showPositiveMessage(action.message, context);
      }
      if (action is FinishScreen) {
        Navigator.pop(context, true);
      }
    });
  }

  Widget _getWidgetByHistoryType(AddTimelineState state) {
    var currentHistoricType = state.currentHistoricType;

    onTap(HistoricType historic){
       _controller.tapOnUpdateHistoric(historic);
    }

    if (currentHistoricType is ChangedOil) {
      return ChangeOilInput(
        changedOil: currentHistoricType,
        isLoading: state.isLoading,
        onConfirm: onTap,
      );
    } else if (currentHistoricType is CarInMaintenance) {
      return CarInMaintenanceInput(
        carInMaintenance: currentHistoricType,
        isLoading: state.isLoading,
        onConfirm: onTap,
      );
    } else if (currentHistoricType is RegisterKM) {
      return RegisterKmInput(
        registerKM: currentHistoricType,
        isLoading: state.isLoading,
        onConfirm: onTap,
      );
    } else if (currentHistoricType is PrejudiceCar) {
      return PrejudiceCarInput(
        prejudiceCar: currentHistoricType,
        isLoading: state.isLoading,
        onConfirm: onTap,
      );
    } else if (currentHistoricType is ReturnMaintenance) {
      return ReturnMaintenanceInput(
        returnMaintenance: currentHistoricType,
        isLoading: state.isLoading,
        onConfirm:onTap,
      );
    } else if (currentHistoricType is PaymentCar) {
      return PaymentCarInput(
        paymentCar: currentHistoricType,
        isLoading: state.isLoading,
        onConfirm: onTap,
      );
    } else {
      return const SizedBox();
    }
  }
}
