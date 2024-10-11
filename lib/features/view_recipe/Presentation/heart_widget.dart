import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

Color primary = const Color(0xFFFA6375);

// ignore: camel_case_types, must_be_immutable
class customHeartFavoris extends StatefulWidget {

  customHeartFavoris(
      {Key? key, required this.isSelected, required this.isChecked})
      : super(key: key);
  final ValueChanged<bool> isChecked;
  bool isSelected;


  @override
  State<customHeartFavoris> createState() => _customHeartFavorisState();
}

class _customHeartFavorisState extends State<customHeartFavoris> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
          widget.isChecked(widget.isSelected);
          //   widget.isChecked(widget.isSelected);
        });
      },
      child: AnimatedContainer(
        // height: 25,
        // width: 25,
        duration: const Duration(milliseconds: 0),
        child: widget.isSelected
            ? Icon(
                Ionicons.heart,
                color: primary,
              )
            : const Icon(
                Ionicons.heart_outline,
                color: null,
              ),
      ),
    );
  }
}
