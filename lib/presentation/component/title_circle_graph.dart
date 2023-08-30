import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/res/custom_colors.dart';

import 'circle_indicator.dart';

class TitleCircleGraph extends StatelessWidget {
  final double value;
  final String title;

  const TitleCircleGraph({Key? key, required this.value, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.primaryColor),
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 12),
        CircleProgressIndicator(
          backgroundColor: const Color(0xffb9ddff),
          value: value,
          size: 80,
          progressColor: Colors.green,
          strokeWidth: 12,
        ),
      ],
    );
  }
}
