import 'package:dar_care/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

abstract class AppRouter {
  static const String splashPath = '/';
  static const String onboardingPath = '/onboarding';
  static final router = GoRouter(
    initialLocation: splashPath,
    routes: [
      GoRoute(
        path: splashPath,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboardingPath,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
}
