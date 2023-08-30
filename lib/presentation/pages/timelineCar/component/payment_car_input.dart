import 'package:flutter/material.dart';
import 'package:mobile_manager_car/core/ext/extension.dart';
import 'package:mobile_manager_car/domain/model/historic_type.dart';

import '../../../component/custom_input.dart';
import '../../../component/loading_button.dart';
import '../../../res/strings.dart';

class PaymentCarInput extends StatefulWidget {
  final bool isLoading;
  final PaymentCar paymentCar;
  final Function(PaymentCar) onConfirm;

  const PaymentCarInput({Key? key, required this.paymentCar, required this.onConfirm, required this.isLoading}) : super(key: key);

  @override
  State<PaymentCarInput> createState() => _PaymentCarInputState();
}

class _PaymentCarInputState extends State<PaymentCarInput> {
  final TextEditingController _fieldDateController = TextEditingController();
  final TextEditingController _fieldValueController = TextEditingController();

  @override
  void initState() {
    _setFields();
    super.initState();
  }

  @override
  void dispose() {
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
                widget.onConfirm.call(widget.paymentCar);
                },
                loading: widget.isLoading,
                textButton: Strings.save),
          )
        ],
      ),
    );
  }

  void _setFields() {
    _fieldDateController.text = widget.paymentCar.date.dateToString();

  }

  void _getFields() {
     widget.paymentCar.dateTime = _fieldDateController.text.toDate("dd/MM/yyyy");
     widget.paymentCar.date = _fieldDateController.text.toDate("dd/MM/yyyy");
     widget.paymentCar.historicRent.valueRent = double.parse(_fieldValueController.text);
  }
}
