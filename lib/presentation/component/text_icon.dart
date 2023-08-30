import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final String text;
  final IconData icon;
  final TextStyle textStyle;
  final TextAlign? textAlign;
  final double sizeIcon;

  const IconText({Key? key, required this.text, required this.icon, required this.textStyle, this.sizeIcon = 9, this.textAlign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(icon, size: sizeIcon),
              SizedBox(width: 6),
              Text(text, style: textStyle, textAlign: textAlign),
            ],
          ),
        ],
      ),
    );
  }
}
