import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';

class ProviderMainScreen extends StatefulWidget {
  const ProviderMainScreen({super.key});

  @override
  State<ProviderMainScreen> createState() => _ProviderMainScreenState();
}

class _ProviderMainScreenState extends State<ProviderMainScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    const Center(child: Text('Provider Dashboard Placeholder')),
    const Center(child: Text('Provider Requests Placeholder')),
    const Center(child: Text('Provider Earnings Placeholder')),
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LocaleKeys.profile_screen_placeholder.tr()),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(SolarLinearIcons.logout, color: Colors.white),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
        body: _screens[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          backgroundColor: Colors.transparent,
          color: isDark ? AppColors.deepDarkGreen : Colors.white,
          buttonBackgroundColor: AppColors.brightGreen,
          animationDuration: const Duration(milliseconds: 300),
          items: const [
            Icon(SolarLinearIcons.widget, size: 30),
            Icon(SolarLinearIcons.clipboardList, size: 30),
            Icon(SolarLinearIcons.wallet, size: 30),
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
