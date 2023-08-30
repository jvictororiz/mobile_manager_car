import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import '../../../component/custom_input.dart';
import '../../../component/loading_button.dart';
import '../../../res/strings.dart';

class CarInMaintenanceInput extends StatefulWidget {
  final bool isLoading;
  final CarInMaintenance carInMaintenance;
  final Function(CarInMaintenance) onConfirm;

  const CarInMaintenanceInput({Key? key, required this.carInMaintenance, required this.onConfirm, required this.isLoading}) : super(key: key);

  @override
  State<CarInMaintenanceInput> createState() => _CarInMaintenanceInputState();
}

class _CarInMaintenanceInputState extends State<CarInMaintenanceInput> {
  final TextEditingController _fieldObservationsController = TextEditingController();
  final TextEditingController _fieldDateController = TextEditingController();

  @override
  void initState() {
    _setFields();
    super.initState();
  }

  @override
  void dispose() {
    _fieldObservationsController.dispose();
    _fieldDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CustomInput(
            marginTop: 18,
            marginHorizontal: 16,
            hintText: "Data",
            mask: "dd/MM/yyyy",
            prefixIcon: const Icon(Icons.date_range),
            keyboardType: TextInputType.number,
            controller: _fieldDateController,
          ),
          CustomInput(
            marginTop: 18,
            marginHorizontal: 16,
            hintText: "Observações",
            minLines: 3,
            textStyle: const TextStyle(fontSize: 16),
            prefixIcon: const Icon(Icons.description_outlined),
            keyboardType: TextInputType.multiline,
            controller: _fieldObservationsController,
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(15),
            child: LoadingButton(
                onTap: () {
                  _getFields();
                  widget.onConfirm.call(widget.carInMaintenance);
                },
                loading: widget.isLoading,
                textButton: Strings.save),
          )
        ],
      ),
    );
  }

  void _setFields() {
    _fieldDateController.text = widget.carInMaintenance.date.dateToString();
    _fieldObservationsController.text = widget.carInMaintenance.motive;
  }

  void _getFields() {
    widget.carInMaintenance.dateTime = _fieldDateController.text.toDate("dd/MM/yyyy");
    widget.carInMaintenance.date = _fieldDateController.text.toDate("dd/MM/yyyy");
    widget.carInMaintenance.motive = _fieldObservationsController.text;
  }
}
