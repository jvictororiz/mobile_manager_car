import 'package:flutter/material.dart';

class InfoHeaderComponent extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;
  final String description;

  const InfoHeaderComponent({Key? key, required this.color, required this.title, required this.icon, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VerticalDivider(
            width: 2,
            thickness: 1,
            color: color,
          ),
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title),
                  const SizedBox(height: 6),
                  Row(
                    children: [Icon(icon, size: 15,), const SizedBox(width: 8), Text(description)],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
