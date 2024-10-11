import 'package:flutter/material.dart';
import 'package:ukla_app/features/view_recipe/Presentation/Widgets/nutritive_fact/my_painter.dart';

class MyArc extends StatelessWidget {
  final double diameter;
  final Color color;
  const MyArc({super.key, required this.diameter, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(color: color),
      size: Size(diameter, diameter),
    );
  }
}
