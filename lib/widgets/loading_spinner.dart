import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingSpinner extends StatefulWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  final Duration animationDuration;

  const LoadingSpinner({
    super.key,
    this.color = Colors.blue,
    this.size = 50.0,
    this.strokeWidth = 2.0,
    this.animationDuration = const Duration(seconds: 3),
  });

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  // Color color = Colors.blue,
  // double size = 50.0,
  // double strokeWidth = 2.0,
  // Duration animationDuration = const Duration(seconds: 3)

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _rotationAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IgnorePointer(
          child: Container(
            color: Colors.black54,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: _rotationAnimation.value *
                  2 *
                  3.1415, // Convert rotation to radians
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _LoadingPainter(
                  color: widget.color,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _LoadingPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw the dotted circle line
    final dottedCirclePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeMiterLimit = 2.0;
    const dotCount = 30;
    //final dotSpacing = 2 * 3.1415 * radius / dotCount;
    for (var i = 0; i < dotCount; i++) {
      final dotAngle = i * (2 * 3.1415 / dotCount);
      final startX = center.dx + radius * cos(dotAngle);
      final startY = center.dy + radius * sin(dotAngle);
      final endX = center.dx + (radius - strokeWidth) * cos(dotAngle);
      final endY = center.dy + (radius - strokeWidth) * sin(dotAngle);
      canvas.drawLine(
          Offset(startX, startY), Offset(endX, endY), dottedCirclePaint);
    }

    // Draw the solid circle line
    final solidCircleRect =
        Rect.fromCircle(center: center, radius: radius - strokeWidth);
    canvas.drawArc(solidCircleRect, 0, 2 * 3.1415, false, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
