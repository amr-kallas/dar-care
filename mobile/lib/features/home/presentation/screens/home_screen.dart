import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/client_home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ClientHomeBody(),
    Center(child: Text(LocaleKeys.orders_screen_placeholder.tr())),
    Center(child: Text(LocaleKeys.favorites_screen_placeholder.tr())),
    Center(child: Text(LocaleKeys.profile_screen_placeholder.tr())),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: isDark ? AppColors.deepDarkGreen : Colors.white,
        indicatorColor: AppColors.brightGreen.withValues(alpha: 0.2),
        elevation: 0,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppColors.brightGreen),
            label: LocaleKeys.home_tab.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long, color: AppColors.brightGreen),
            label: LocaleKeys.orders_tab.tr(),
          ),
           NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite, color: AppColors.brightGreen),
            label: LocaleKeys.favorites_tab.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person, color: AppColors.brightGreen),
            label: LocaleKeys.profile_tab.tr(),
          ),
        ],
      ),
    );
  }
}
