import 'package:flutter/material.dart';

class GetStartedMyCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path(); // use for shape your container

    path.lineTo(-70, size.height / 8.5);

    path.quadraticBezierTo(size.width / 2, -20, size.width, size.height / 5);
    path.lineTo(size.width, 30);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class GetStartedMyCustomShapeWithOpacity extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path(); // use for shape your container

    path.lineTo(-70, size.height / 8);

    path.quadraticBezierTo(size.width / 2, -20, size.width, size.height / 3.5);
    path.lineTo(size.width, 30);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
