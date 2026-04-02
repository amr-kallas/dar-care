import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/chat/presentation/provider/screens/provider_chats_screen.dart';
import 'package:dar_care/features/profile/presentation/provider/screens/provider_profile_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import 'package:dar_care/features/home/presentation/provider/cubit/provider_home_cubit.dart';
import 'package:dar_care/features/home/presentation/provider/screens/provider_home_screen.dart';

import '../../../../orders/presentation/provider/screens/provider_orders_screen.dart';

class ProviderMainScreen extends StatefulWidget {
  const ProviderMainScreen({super.key});

  @override
  State<ProviderMainScreen> createState() => _ProviderMainScreenState();
}

class _ProviderMainScreenState extends State<ProviderMainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    BlocProvider(
      create: (context) =>
          ProviderHomeCubit(getIt())..loadDashboard(),
      child: const ProviderHomeScreen(),
    ),
    const ProviderOrdersScreen(),
    const ProviderChatsScreen(),
    const ProviderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignOutSuccess || state is AuthUnauthenticated) {
          context.go(AppRouter.loginPath);
        } else if (state is AuthError) {
          AppSnackbar.showError(context, state.messageKey.tr());
        }
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          backgroundColor: Colors.transparent,
          color: isDark ? AppColors.deepDarkGreen : Colors.green.shade50,
          buttonBackgroundColor: AppColors.brightGreen,
          animationDuration: const Duration(milliseconds: 300),
          items: const [
            Icon(SolarLinearIcons.home, size: 30),
            Icon(SolarLinearIcons.billList, size: 30),
            Icon(SolarLinearIcons.chatRoundLine, size: 30),
            Icon(SolarLinearIcons.user, size: 30),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
