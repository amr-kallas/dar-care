import 'package:flutter/material.dart';

class AuthFooterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width / 8,
      0,
      size.width / 2,
      size.height * 0.1,
    );
    path.quadraticBezierTo(
      size.width * 7 / 8,
      size.height * 0.18,
      size.width,
      size.height * 0.05,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
