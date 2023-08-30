import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import '../../../component/custom_input.dart';
import '../../../component/loading_button.dart';
import '../../../res/strings.dart';

class ChangeOilInput extends StatefulWidget {
  final bool isLoading;
  final ChangedOil changedOil;
  final Function(ChangedOil) onConfirm;

  const ChangeOilInput({Key? key, required this.changedOil, required this.onConfirm, required this.isLoading}) : super(key: key);

  @override
  State<ChangeOilInput> createState() => _ChangeOilInputState();
}

class _ChangeOilInputState extends State<ChangeOilInput> {
  final TextEditingController _fieldKmController = TextEditingController();
  final TextEditingController _fieldValueController = TextEditingController();
  final TextEditingController _fieldDateController = TextEditingController();

  @override
  void initState() {
    _setFields();
    super.initState();
  }

  @override
  void dispose() {
    _fieldKmController.dispose();
    _fieldValueController.dispose();
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
            hintText: "KM atual",
            prefixIcon: const Icon(Icons.running_with_errors_outlined),
            keyboardType: TextInputType.number,
            controller: _fieldKmController,
          ),
          CustomInput(
            marginTop: 18,
            marginHorizontal: 16,
            hintText: "Valor pago",
            prefixIcon: const Icon(Icons.monetization_on_rounded),
            keyboardType: TextInputType.number,
            controller: _fieldValueController,
          ),
          CustomInput(
            marginTop: 18,
            marginHorizontal: 16,
            hintText: "Data",
            mask: "dd/MM/yyyy",
            prefixIcon: const Icon(Icons.date_range),
            keyboardType: TextInputType.number,
            controller: _fieldDateController,
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(15),
            child: LoadingButton(
                onTap: () {
                 _getFields();
                widget.onConfirm.call(widget.changedOil);
                },
                loading: widget.isLoading,
                textButton: Strings.save),
          )
        ],
      ),
    );
  }

  void _setFields() {
    _fieldDateController.text = widget.changedOil.historicOil.currentDate.dateToString();
  }

  void _getFields() {
     widget.changedOil.dateTime = _fieldDateController.text.toDate("dd/MM/yyyy");
     widget.changedOil.historicOil.currentDate = _fieldDateController.text.toDate("dd/MM/yyyy");
     widget.changedOil.historicOil.currentKm = double.parse(_fieldKmController.text);
     widget.changedOil.historicOil.value = double.parse(_fieldValueController.text);

  }
}
