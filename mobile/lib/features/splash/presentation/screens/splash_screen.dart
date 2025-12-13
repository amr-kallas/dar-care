import 'package:dar_care/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/animated_logo.dart';
import '../widget/sliding_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoFadeAnimation;

  late AnimationController _textAnimationController;
  late Animation<Offset> _textSlidingAnimation;

  @override
  void initState() {
    super.initState();
    initAnimations();
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  void initAnimations() {
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_logoAnimationController);

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _textSlidingAnimation =
        Tween<Offset>(begin: const Offset(0, 5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _textAnimationController,
            curve: Curves.easeOut,
          ),
        );

    _logoAnimationController.forward();
    _textAnimationController.forward();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRouter.onboardingPath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedLogo(animation: _logoFadeAnimation),
            SlidingText(slidingAnimation: _textSlidingAnimation),
          ],
        ),
      ),
    );
  }
}
