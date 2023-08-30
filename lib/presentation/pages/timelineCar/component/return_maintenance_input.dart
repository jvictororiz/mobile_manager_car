import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import '../../../component/custom_input.dart';
import '../../../component/loading_button.dart';
import '../../../res/strings.dart';

class ReturnMaintenanceInput extends StatefulWidget {
  final bool isLoading;
  final ReturnMaintenance returnMaintenance;
  final Function(ReturnMaintenance) onConfirm;

  const ReturnMaintenanceInput({Key? key, required this.returnMaintenance, required this.onConfirm, required this.isLoading}) : super(key: key);

  @override
  State<ReturnMaintenanceInput> createState() => _ReturnMaintenanceInputState();
}

class _ReturnMaintenanceInputState extends State<ReturnMaintenanceInput> {
  final TextEditingController _fieldObservationsController = TextEditingController();
  final TextEditingController _fieldDateController = TextEditingController();
  final TextEditingController _fieldValueController = TextEditingController();

  @override
  void initState() {
    _setFields();
    super.initState();
  }

  @override
  void dispose() {
    _fieldObservationsController.dispose();
    _fieldDateController.dispose();
    _fieldValueController.dispose();
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
            hintText: "Valor",
            prefixIcon: const Icon(Icons.monetization_on_rounded),
            keyboardType: TextInputType.number,
            controller: _fieldValueController,
          ),
          CustomInput(
            marginTop: 18,
            marginHorizontal: 16,
            hintText: "Observações",
            minLines: 4,
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
                widget.onConfirm.call(widget.returnMaintenance);
                },
                loading: widget.isLoading,
                textButton: Strings.save),
          )
        ],
      ),
    );
  }

  void _setFields() {
    _fieldDateController.text = widget.returnMaintenance.date.dateToString();
    _fieldObservationsController.text = widget.returnMaintenance.motive;
    _fieldValueController.text = widget.returnMaintenance.motive;
  }

  void _getFields() {
     widget.returnMaintenance.date = _fieldDateController.text.toDate("dd/MM/yyyy");
     widget.returnMaintenance.dateTime = _fieldDateController.text.toDate("dd/MM/yyyy");
     widget.returnMaintenance.motive = _fieldObservationsController.text;
  }
}
