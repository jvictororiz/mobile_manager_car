import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import '../../../component/custom_input.dart';
import '../../../component/loading_button.dart';
import '../../../res/strings.dart';

class PrejudiceCarInput extends StatefulWidget {
  final bool isLoading;
  final PrejudiceCar prejudiceCar;
  final Function(PrejudiceCar) onConfirm;

  const PrejudiceCarInput({Key? key, required this.prejudiceCar, required this.onConfirm, required this.isLoading}) : super(key: key);

  @override
  State<PrejudiceCarInput> createState() => _PrejudiceCarInputState();
}

class _PrejudiceCarInputState extends State<PrejudiceCarInput> {
  final TextEditingController _fieldDateController = TextEditingController();
  final TextEditingController _fieldValueController = TextEditingController();
  final TextEditingController _fieldObservationsController = TextEditingController();

  @override
  void initState() {
    _setFields();
    super.initState();
  }

  @override
  void dispose() {
    _fieldValueController.dispose();
    _fieldDateController.dispose();
    _fieldObservationsController.dispose();
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
          CustomInput(
            marginTop: 18,
            marginHorizontal: 16,
            hintText: "Observações",
            minLines: 3,
            textStyle: const TextStyle(fontSize: 18),
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
                  widget.onConfirm.call(widget.prejudiceCar);
                },
                loading: widget.isLoading,
                textButton: Strings.save),
          )
        ],
      ),
    );
  }

  void _setFields() {
    _fieldDateController.text = widget.prejudiceCar.date.dateToString();
  }

  void _getFields() {
    widget.prejudiceCar.dateTime = _fieldDateController.text.toDate("dd/MM/yyyy");
    widget.prejudiceCar.date = _fieldDateController.text.toDate("dd/MM/yyyy");
    widget.prejudiceCar.prejudice = double.parse(_fieldValueController.text);
    widget.prejudiceCar.observation = _fieldObservationsController.text;
  }
}
