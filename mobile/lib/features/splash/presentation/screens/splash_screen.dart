import 'package:dar_care/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dar_care/core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../config/splash_config.dart';
import '../controllers/splash_animation_controller.dart';
import '../widget/animated_logo.dart';
import '../widget/sliding_text.dart';

/// Splash screen displayed when the app launches
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final SplashAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _scheduleNavigation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Initialize all splash animations
  void _initializeAnimations() {
    _animationController = SplashAnimationController(
      vsync: this,
      logoAnimationDuration: SplashConfig.logoAnimationDuration,
      textAnimationDuration: SplashConfig.textAnimationDuration,
    );
    _animationController.startAnimations();
  }

  /// Schedule navigation to the next screen
  void _scheduleNavigation() {
    Future.delayed(SplashConfig.splashDuration, () {
      if (mounted) {
        final hasSession = SupabaseService.auth.currentSession != null;
        if (hasSession) {
          context.go(AppRouter.homePath);
        } else {
          context.go(AppRouter.onboardingPath);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryDeepGreen,
              AppColors.brightGreen,
              AppColors.lightGreen,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedLogo(animation: _animationController.logoFadeAnimation),
              SlidingText(
                slidingAnimation: _animationController.textSlidingAnimation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
