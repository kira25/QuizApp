import 'package:flutter/material.dart';

class CustomClipPathDark extends CustomClipper<Path> {
  var radius = 15.0;
  @override
  getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.9,
        size.width * 0.50, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.50,
        size.width * 0.85, size.height * 0.35);
    path.quadraticBezierTo(
        size.width * 0.95, size.height * 0.28, size.width, size.height * 0.20);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}