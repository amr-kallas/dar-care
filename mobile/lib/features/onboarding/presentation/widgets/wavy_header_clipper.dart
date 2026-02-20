import 'package:flutter/material.dart';

class WavyHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top left
    path.lineTo(0, size.height * 0.75);

    // Create a smoother, more modern wave pattern
    // First curve (left to center)
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.85,
      size.width * 0.5,
      size.height * 0.80,
    );

    // Second curve (center to right)
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.75,
      size.width,
      size.height * 0.85,
    );

    // Complete the path
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

/// Alternative wavy clipper with deeper waves
class DeepWavyHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.7);

    // Create deeper, more dramatic waves
    var firstControlPoint = Offset(size.width * 0.15, size.height * 0.9);
    var firstEndPoint = Offset(size.width * 0.3, size.height * 0.75);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 0.5, size.height * 0.55);
    var secondEndPoint = Offset(size.width * 0.7, size.height * 0.75);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    var thirdControlPoint = Offset(size.width * 0.85, size.height * 0.9);
    var thirdEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      thirdControlPoint.dx,
      thirdControlPoint.dy,
      thirdEndPoint.dx,
      thirdEndPoint.dy,
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
