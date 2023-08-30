import 'package:flutter/material.dart';

class ProgressHorizontal extends StatelessWidget {
  final Color color;
  final double percent;
  const ProgressHorizontal({Key? key, required this.color, this.percent = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 2,
      width: 50,
      color: color.withAlpha(50),
      child: Stack(
        children: [
          Container(
            height: 2,
            width: percent / 2,
            color: color,
          ),
        ],
      ),
    );
  }
}
