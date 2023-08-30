import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:mobile_manager_car/domain/util/ext.dart';

class CircleProgressIndicator extends StatefulWidget {
  final double value;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;
  final double size;

  CircleProgressIndicator({
    required this.value,
    this.size = 80,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.strokeWidth = 10.0,
  });

  @override
  _CircleProgressIndicatorState createState() => _CircleProgressIndicatorState();
}

class _CircleProgressIndicatorState extends State<CircleProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  var showedAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CircleProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: 0, end: widget.value).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: CircleProgressPainter(
                  value: _animation.value,
                  backgroundColor: widget.backgroundColor,
                  progressColor: widget.progressColor,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
            ),
            Text(
              widget.value.toPercentageString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.size / 7, color: widget.progressColor),
            )
          ],
        );
      },
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double value;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  CircleProgressPainter({
    required this.value,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth / 3;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressAngle = 2 * math.pi * (value / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
