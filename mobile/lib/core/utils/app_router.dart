import 'package:dar_care/features/auth/presentation/models/auth_registration_data.dart';
import 'package:dar_care/features/auth/presentation/screens/auth_gate_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/login_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/provider_signup_screen.dart';
import 'package:dar_care/features/auth/presentation/screens/signup_screen.dart';
import 'package:dar_care/features/chat/presentation/client/screens/chat_screen.dart';
import 'package:dar_care/features/location_setup/presentation/screens/location_setup_screen.dart';
import 'package:dar_care/features/orders/presentation/client/screens/orders_screen.dart';
import 'package:dar_care/features/orders/presentation/provider/screens/provider_order_details_entry_screen.dart';
import 'package:dar_care/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

import 'package:dar_care/features/home/presentation/home_screen.dart';
import 'package:dar_care/features/home/data/models/category_model.dart';
import 'package:dar_care/features/home/presentation/client/screens/all_departments_screen.dart';
import 'package:dar_care/features/home/presentation/client/screens/all_providers_screen.dart';
import 'package:dar_care/features/home/presentation/client/screens/sub_categories_screen.dart';
import 'package:dar_care/features/search/presentation/screens/search_results_screen.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:dar_care/features/profile/presentation/provider/screens/provider_edit_profile_screen.dart';
import 'package:dar_care/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:dar_care/features/notifications_history/presentation/screens/notifications_history_screen.dart';

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
  static const String allDepartmentsPath = '/all-departments';
  static const String subCategoriesPath = '/sub-categories';
  static const String allProvidersPath = '/all-providers';
  static const String editProfilePath = '/edit-profile';
  static const String providerEditProfilePath = '/provider-edit-profile';
  static const String chatRoomPath = '/chat-room';
  static const String myOrdersPath = '/my-orders';
  static const String providerOrderDetailsPath = '/provider-order-details/:orderId';
  static const String notificationsHistoryPath = '/notifications-history';

  static String buildChatRoomPath({
    required String providerId,
    required String clientId,
    String? title,
  }) {
    final params = <String, String>{
      'providerId': providerId,
      'clientId': clientId,
      if (title != null && title.trim().isNotEmpty) 'title': title,
    };

    return Uri(path: chatRoomPath, queryParameters: params).toString();
  }

  static String buildProviderOrderDetailsPath(String orderId) {
    return '/provider-order-details/$orderId';
  }

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
      GoRoute(
        path: allDepartmentsPath,
        name: 'all-departments',
        builder: (context, state) {
          final extra = state.extra;
          final categories = extra is List<CategoryModel>
              ? extra
              : const <CategoryModel>[];
          return AllDepartmentsScreen(categories: categories);
        },
      ),
      GoRoute(
        path: subCategoriesPath,
        name: 'sub-categories',
        builder: (context, state) {
          final extra = state.extra;
          final department = extra is CategoryModel ? extra : null;
          return department != null
              ? SubCategoriesScreen(department: department)
              : const Scaffold(body: Center(child: Text('Invalid department')));
        },
      ),
      GoRoute(
        path: allProvidersPath,
        name: 'all-providers',
        builder: (context, state) {
          final extra = state.extra;
          final providers = extra is List<ProviderModel>
              ? extra
              : const <ProviderModel>[];
          return AllProvidersScreen(providers: providers);
        },
      ),
      GoRoute(
        path: editProfilePath,
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: providerEditProfilePath,
        name: 'provider-edit-profile',
        builder: (context, state) => const ProviderEditProfileScreen(),
      ),
      GoRoute(
        path: chatRoomPath,
        name: 'chat-room',
        builder: (context, state) {
          final currentUserId = Supabase.instance.client.auth.currentUser?.id;
          final providerId = state.uri.queryParameters['providerId'];
          final clientId = state.uri.queryParameters['clientId'];
          final title = state.uri.queryParameters['title'];

          if (currentUserId == null || providerId == null || clientId == null) {
            return const Scaffold(
              body: Center(child: Text('Unable to open this chat.')),
            );
          }

          return ChatScreen(
            currentUserId: currentUserId,
            providerId: providerId,
            explicitClientId: clientId,
            title: title,
          );
        },
      ),
      GoRoute(
        path: myOrdersPath,
        name: 'my-orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: providerOrderDetailsPath,
        name: 'provider-order-details',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'];
          if (orderId == null || orderId.trim().isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Unable to open order details.')),
            );
          }
          return ProviderOrderDetailsEntryScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: notificationsHistoryPath,
        name: 'notifications-history',
        builder: (context, state) => const NotificationsHistoryScreen(),
      ),
    ],
  );
}
