import 'package:flutter/material.dart';
import 'dart:math' as math;

// This is the Painter class

class MyPainter extends CustomPainter {
  Color color;
  MyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height * 0.7,
        width: size.width * 0.9,
      ),
      math.pi,
      -math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
