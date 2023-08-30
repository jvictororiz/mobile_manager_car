import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  final String text;
  final GestureTapCallback? onTap;
  final IconData? icon;

  const ButtonAction({
    Key? key,
    required this.text,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Wrap(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(width: 6),
              icon != null ? Icon(icon) : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
