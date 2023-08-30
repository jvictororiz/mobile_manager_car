import 'package:flutter/material.dart';

class DiagonalWidget extends StatelessWidget {

  final String text;
  final Color color;
  const DiagonalWidget({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Transform.rotate(
          angle: -0.785398, // Ângulo de rotação em radianos (45 graus)
          child: Center(
            child: Container(
              padding: EdgeInsets.all(5),

              color: color,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
