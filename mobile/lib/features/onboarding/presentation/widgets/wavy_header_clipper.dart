import 'package:flutter/material.dart';

class WavyHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height * 0.70,
      size.width,
      size.height * 0.85,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
