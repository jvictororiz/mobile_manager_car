import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/component/progress_horizontal.dart';

class InfoHorizontalHeader extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final double percent;

  const InfoHorizontalHeader({
    Key? key,
    required this.color,
    required this.title,
    required this.description,
    required this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
        const SizedBox(height: 5),
        ProgressHorizontal(color: color, percent: percent),
        const SizedBox(height: 5),
        Text(description, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
