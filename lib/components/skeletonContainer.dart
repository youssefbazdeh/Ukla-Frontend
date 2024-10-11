import 'package:flutter/material.dart';

class GreyContainer extends StatefulWidget {
  const GreyContainer(
      {required this.circular,
      required this.height,
      required this.width,
      Key? key})
      : super(key: key);
  final double circular;
  final double height;
  final double width;

  @override
  State<GreyContainer> createState() => _GreyContainerState();
}

class _GreyContainerState extends State<GreyContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.circular),
          color: const Color(0XFFC4C4C4)),
    );
  }
}
