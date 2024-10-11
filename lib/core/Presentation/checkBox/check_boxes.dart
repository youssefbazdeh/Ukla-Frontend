import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

Color primary = const Color(0xFFFA6375);

class CustomCheckBox extends StatefulWidget {
  bool isSelected = false;

  CustomCheckBox(
      {Key? key,
      required this.size,
      required this.raduisBorder,
      required this.isSelected,
      required this.isChecked})
      : super(key: key);
  final ValueChanged<bool> isChecked;
  final double size;
  final double raduisBorder;
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
          widget.isChecked(widget.isSelected);
        });
      },
      child: AnimatedContainer(
        height: widget.size,
        width: widget.size,
        duration: const Duration(milliseconds: 0),
        decoration: BoxDecoration(
            border: widget.isSelected == false
                ? Border.all(color: Colors.black)
                : Border.all(color: primary),
            borderRadius: BorderRadius.circular(widget.raduisBorder),
            color: widget.isSelected == true ? primary : Colors.transparent),
        child: widget.isSelected == true
            ? Icon(
                Ionicons.checkmark,
                size: widget.size,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

class StepsCheck extends StatefulWidget {
  const StepsCheck({Key? key}) : super(key: key);

  @override
  State<StepsCheck> createState() => _StepsCheckState();
}

class _StepsCheckState extends State<StepsCheck> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: AnimatedContainer(
        child: isSelected
            ? const Icon(Ionicons.checkmark, color: Colors.white)
            : null,
        duration: const Duration(milliseconds: 200),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: isSelected ? primary : Colors.transparent,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: primary)
                : Border.all(color: Colors.black)),
      ),
    );
  }
}
