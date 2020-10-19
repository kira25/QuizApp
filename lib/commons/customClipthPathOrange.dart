import 'package:flutter/material.dart';

class CustomClipPathOrange extends CustomClipper<Path> {
  var radius = 15.0;
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.9,
        size.width * 0.30, size.height * 0.42);

    path.quadraticBezierTo(
        size.width * 0.35, size.height * 0.15, size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}