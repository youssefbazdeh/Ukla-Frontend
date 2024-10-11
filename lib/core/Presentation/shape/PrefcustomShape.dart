import 'package:flutter/material.dart';

class PrefMyCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path(); // use for shape your container
    path.lineTo(0, 0);
    path.lineTo(0, 15);
    path.quadraticBezierTo(size.width / 20, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - size.width / 20, 0, size.width, 15);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
