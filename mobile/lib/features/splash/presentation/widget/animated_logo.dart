import 'package:dar_care/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import '../config/splash_config.dart';

/// Animated logo widget with fade-in animation
class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required this.animation,
  });

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Assets.images.png.dareCareLogo.image(
        width: SplashConfig.logoSize,
        height: SplashConfig.logoSize,
      ),
    );
  }
}
