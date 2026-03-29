import 'package:dar_care/features/auth/presentation/models/auth_registration_data.dart';
import 'package:dar_care/features/auth/presentation/screens/auth_gate_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/login_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/provider_signup_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/signup_screen.dart';
import 'package:dar_care/features/location_setup/presentation/screens/location_setup_screen.dart';
import 'package:dar_care/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

import 'package:dar_care/features/home/presentation/home_screen.dart';
import 'package:dar_care/features/search/presentation/screens/search_results_screen.dart';

abstract class AppRouter {
  static const String splashPath = '/';
  static const String onboardingPath = '/onboarding';
  static const String authGatePath = '/auth-gate';
  static const String loginPath = '/login';
  static const String signupPath = '/signup';
  static const String providerSignupPath = '/provider-signup';
  static const String forgotPasswordPath = '/forgot-password';
  static const String otpVerificationPath = '/otp-verification';
  static const String locationSetupPath = '/location-setup';
  static const String homePath = '/home';
  static const String searchResultsPath = '/search-results';

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
      GoRoute(
        path: authGatePath,
        name: 'auth-gate',
        builder: (context, state) => const AuthGateScreen(),
      ),
      GoRoute(
        path: loginPath,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signupPath,
        name: 'signup',
        builder: (context, state) {
          final registrationData = state.extra is AuthRegistrationData
              ? state.extra as AuthRegistrationData
              : null;
          return SignupScreen(registrationData: registrationData);
        },
      ),
      GoRoute(
        path: providerSignupPath,
        name: 'provider-signup',
        builder: (context, state) {
          final registrationData = state.extra is AuthRegistrationData
              ? state.extra as AuthRegistrationData
              : null;
          return ProviderSignupScreen(registrationData: registrationData);
        },
      ),
      GoRoute(
        path: forgotPasswordPath,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: otpVerificationPath,
        name: 'otp-verification',
        builder: (context, state) {
          final String? phoneNumber = state.extra as String?;
          return OtpVerificationScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: locationSetupPath,
        name: 'location-setup',
        builder: (context, state) => const LocationSetupScreen(),
      ),
      GoRoute(
        path: homePath,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: searchResultsPath,
        name: 'search-results',
        builder: (context, state) {
          final extraQuery = state.extra is String
              ? state.extra as String
              : null;
          final query = extraQuery ?? state.uri.queryParameters['q'];
          return SearchResultsScreen(initialQuery: query);
        },
      ),
    ],
  );
}
