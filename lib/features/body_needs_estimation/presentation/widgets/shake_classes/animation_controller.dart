
import 'dart:math';

import 'package:flutter/material.dart';

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);
  final Duration animationDuration;
  late final animationController = AnimationController(
    vsync: this,
    duration: animationDuration
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
class SineCurve extends Curve {
  const SineCurve({this.count = 3});
  final double count;

  // 2. override transformInternal() method
  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}