import 'package:flutter/material.dart';

class CustomClipPathBlue extends CustomClipper<Path> {
  var radius = 15.0;
  @override
  getClip(Size size) {
    var path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.70);

    path.quadraticBezierTo(size.width * 0.4, size.height * 0.7, 0, 0);

    path.close();

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}