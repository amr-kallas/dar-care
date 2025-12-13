import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key, required this.animation});

  final Animation<double> animation;
  final String logoPath = 'assets/images/png/DareCareLogo.png';

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Image.asset(logoPath, width: 200, height: 200),
    );
  }
}
