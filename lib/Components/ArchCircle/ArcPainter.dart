import 'package:flutter/material.dart';
import 'dart:math' as math;

Paint createPaintForColor(Color color) {
  return Paint()
    ..color = color
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 15;
}

class ArcPainter extends CustomPainter {
  final double radius;
  final String position;
  final Color color;
  // final Paint red = createPaintForColor(Colors.red);
  // final Paint blue = createPaintForColor(Colors.blue);

  ArcPainter(this.radius, this.position, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);
    if (position == "left") {
      canvas.drawArc(rect, 0, sweepAngle(), false, createPaintForColor(color));
    } else if (position == "right") {
      canvas.drawArc(rect, 2 / 4 * math.pi, sweepAngle(), false,
          createPaintForColor(color));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  double sweepAngle() => 0.8 * 2 / 3 * math.pi;
}
