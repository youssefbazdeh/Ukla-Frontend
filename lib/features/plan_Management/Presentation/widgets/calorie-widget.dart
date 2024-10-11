import 'package:flutter/material.dart';

class CaloriesNeeds extends StatefulWidget {
  const CaloriesNeeds(
      {required this.calorieNeeds, required this.calcumClaories, Key? key})
      : super(key: key);

  final double? calorieNeeds;
  final double calcumClaories;

  @override
  State<CaloriesNeeds> createState() => _CaloriesNeedsState();
}

class _CaloriesNeedsState extends State<CaloriesNeeds> {
  @override
  Widget build(BuildContext context) {
    if (widget.calorieNeeds == null) {
      return Text("${widget.calcumClaories.round()} Cal");
    } else {
      return Text(
          "${widget.calcumClaories.round()}/${widget.calorieNeeds!.round()} Cal");
    }
  }
}
