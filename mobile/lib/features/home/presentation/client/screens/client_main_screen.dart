import 'package:dar_care/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import '../../../../orders/presentation/client/screens/orders_screen.dart';
import '../cubit/home_cubit.dart';
import '../widgets/client_home_body.dart';
import 'package:dar_care/features/chat/presentation/client/screens/client_chats_screen.dart';

class ClientMainScreen extends StatefulWidget {
  const ClientMainScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<ClientMainScreen> createState() => _ClientMainScreenState();
}

class _ClientMainScreenState extends State<ClientMainScreen> {
  late int _currentIndex;

  late final List<Widget> _screens = [
    BlocProvider(
      create: (context) => getIt<HomeCubit>()..loadHomeData(),
      child: const ClientHomeBody(),
    ),
    const OrdersScreen(),
    const ClientChatsScreen(),
    const FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _screens.length - 1);
  }

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
