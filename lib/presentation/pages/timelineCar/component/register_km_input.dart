import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import '../../../component/custom_input.dart';
import '../../../component/loading_button.dart';
import '../../../res/strings.dart';

class RegisterKmInput extends StatefulWidget {
  final bool isLoading;
  final RegisterKM registerKM;
  final Function(RegisterKM) onConfirm;

  const RegisterKmInput({Key? key, required this.registerKM, required this.onConfirm, required this.isLoading}) : super(key: key);

  @override
  State<RegisterKmInput> createState() => _RegisterKmInputState();
}

class _RegisterKmInputState extends State<RegisterKmInput> {
  final TextEditingController _fieldKm = TextEditingController();
  final TextEditingController _fieldDateController = TextEditingController();

  @override
  void initState() {
    _setFields();
    super.initState();
  }

  @override
  void dispose() {
    _fieldKm.dispose();
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
            hintText: "KM",
            prefixIcon: const Icon(Icons.description_outlined),
            keyboardType: TextInputType.number,
            controller: _fieldKm,
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
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(15),
            child: LoadingButton(
                onTap: () {
                  _getFields();
                  widget.onConfirm.call(widget.registerKM);
                },
                loading: widget.isLoading,
                textButton: Strings.save),
          )
        ],
      ),
    );
  }

  void _setFields() {
    _fieldDateController.text = widget.registerKM.dateTime.dateToString();
    _fieldKm.text = widget.registerKM.car.km.toString();
  }

  void _getFields() {
    widget.registerKM.dateTime = _fieldDateController.text.toDate("dd/MM/yyyy");
    widget.registerKM.date = _fieldDateController.text.toDate("dd/MM/yyyy");
    widget.registerKM.newKm = double.parse(_fieldKm.text);
  }
}
