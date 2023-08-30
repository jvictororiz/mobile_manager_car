import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masked_text/masked_text.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    this.hintText = "",
    this.keyboardType = TextInputType.none,
    this.prefixIcon,
    this.isEnable = true,
    this.mask,
    this.maxLength,
    this.marginHorizontal,
    this.marginTop,
    this.inputFormats,
    this.textCapitalization = TextCapitalization.none,
    required this.controller,
    this.minLines,
    this.textStyle,
  });



  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final String hintText;
  final String? mask;
  final TextInputType keyboardType;
  final Icon? prefixIcon;
  final bool isEnable;
  final int? maxLength;
  final int? minLines;
  final double? marginHorizontal;
  final double? marginTop;
  final List<TextInputFormatter>? inputFormats;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: marginTop ?? 0, right: marginHorizontal ?? 0, left: marginHorizontal ?? 0),
      child: MaskedTextField(
        style: textStyle,
        minLines: minLines,
        inputFormatters: inputFormats,
        enabled: isEnable,
        textCapitalization: textCapitalization,
        keyboardType: keyboardType,
        controller: controller,
        maxLength: maxLength,
        maxLines: minLines,
        mask: mask,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon,
          filled: false,
          labelText: hintText,
        ),
      ),
    );
  }
}
