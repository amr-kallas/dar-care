import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/client_home_body.dart';

class ClientMainScreen extends StatefulWidget {
  const ClientMainScreen({super.key});

  @override
  State<ClientMainScreen> createState() => _ClientMainScreenState();
}

class _ClientMainScreenState extends State<ClientMainScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    const ClientHomeBody(),
    Center(child: Text(LocaleKeys.orders_screen_placeholder.tr())),
    Center(child: Text(LocaleKeys.favorites_screen_placeholder.tr())),
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
        if (state is AuthSignOutSuccess) {
          context.go(AppRouter.loginPath);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        extendBody: true,
        body: _screens[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          backgroundColor: Colors.transparent,
          color: isDark ? AppColors.deepDarkGreen : Colors.green.shade50,
          buttonBackgroundColor: AppColors.brightGreen,
          animationDuration: const Duration(milliseconds: 300),
          items: const [
            Icon(SolarLinearIcons.home, size: 30),
            Icon(SolarLinearIcons.billList, size: 30),
            Icon(SolarLinearIcons.heart, size: 30),
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
