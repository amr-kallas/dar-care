import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth/auth_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/logout_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _requestedSessionCheck = false;
  static const Locale _englishLocale = Locale('en');
  static const Locale _arabicLocale = Locale('ar');

  AuthUser? _getCurrentUser(AuthState state) {
    if (state is AuthAuthenticated) return state.user;
    if (state is AuthSignInSuccess) return state.user;
    if (state is AuthSignUpSuccess) return state.user;
    return null;
  }

  void _ensureCurrentUserLoaded(AuthState state) {
    // Only request once on first screen load; avoid racing with sign-out/check flows.
    if (_requestedSessionCheck || state is! AuthInitial) {
      return;
    }

    _requestedSessionCheck = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthCubit>().checkAuthStatus();
      }
    });
  }

  String _currentLanguageLabel(BuildContext context) {
    return context.locale.languageCode == _arabicLocale.languageCode
        ? 'العربية'
        : 'English';
  }

  Future<void> _showLanguagePicker() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLanguageCode = context.locale.languageCode;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'English',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: currentLanguageCode == _englishLocale.languageCode
                      ? Icon(
                          SolarLinearIcons.checkCircle,
                          color: AppColors.brightGreen,
                        )
                      : null,
                  onTap: () async {
                    if (currentLanguageCode != _englishLocale.languageCode) {
                      await context.setLocale(_englishLocale);
                    }
                    if (mounted) Navigator.of(bottomSheetContext).pop();
                  },
                ),
                ListTile(
                  title: Text(
                    'العربية',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: currentLanguageCode == _arabicLocale.languageCode
                      ? Icon(
                          SolarLinearIcons.checkCircle,
                          color: AppColors.brightGreen,
                        )
                      : null,
                  onTap: () async {
                    if (currentLanguageCode != _arabicLocale.languageCode) {
                      await context.setLocale(_arabicLocale);
                    }
                    if (mounted) Navigator.of(bottomSheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _currentThemeLabel() {
    return ThemeController.instance.isDarkMode
        ? 'theme_dark'.tr()
        : 'theme_light'.tr();
  }

  Future<void> _showThemePicker() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentThemeMode = ThemeController.instance.themeMode;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'theme_light'.tr(),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: currentThemeMode == ThemeMode.light
                      ? Icon(
                          SolarLinearIcons.checkCircle,
                          color: AppColors.brightGreen,
                        )
                      : null,
                  onTap: () async {
                    await ThemeController.instance.setThemeMode(ThemeMode.light);
                    if (mounted) Navigator.of(bottomSheetContext).pop();
                  },
                ),
                ListTile(
                  title: Text(
                    'theme_dark'.tr(),
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: currentThemeMode == ThemeMode.dark
                      ? Icon(
                          SolarLinearIcons.checkCircle,
                          color: AppColors.brightGreen,
                        )
                      : null,
                  onTap: () async {
                    await ThemeController.instance.setThemeMode(ThemeMode.dark);
                    if (mounted) Navigator.of(bottomSheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onLogoutPressed(bool isSigningOut) async {
    if (isSigningOut) return;

    final shouldLogout = await showAppConfirmationDialog(
      context: context,
      title: 'logout_confirm_title'.tr(),
      message: 'logout_confirm_message'.tr(),
      confirmText: 'confirm'.tr(),
      cancelText: 'cancel'.tr(),
      isDestructive: true,
    );

    if (!mounted || !shouldLogout) return;
    await context.read<AuthCubit>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.watch<AuthCubit>().state;
    final isSigningOut =
        authState is AuthLoading && authState.operation == AuthOperation.signOut;
    final user = _getCurrentUser(authState);
    _ensureCurrentUserLoaded(authState);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleWidget: Text(
          LocaleKeys.profile_title.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 120.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ProfileHeader(user: user),
            const SizedBox(height: 30),
            ProfileMenuSection(
              title: LocaleKeys.account_tab.tr(),
              children: [
                ProfileMenuItem(
                  title: LocaleKeys.edit_profile.tr(),
                  icon: SolarLinearIcons.pen,
                  isPrimaryIcon: true,
                  onTap: () => context.push(AppRouter.editProfilePath),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ProfileMenuSection(
              title: LocaleKeys.settings_tab.tr(),
              children: [
                ProfileMenuItem(
                  title: LocaleKeys.language.tr(),
                  icon: SolarLinearIcons.global,
                  isPrimaryIcon: true,
                  trailingText: _currentLanguageLabel(context),
                  onTap: _showLanguagePicker,
                ),
                ProfileMenuItem(
                  title: 'theme'.tr(),
                  icon: SolarLinearIcons.moon,
                  isPrimaryIcon: true,
                  trailingText: _currentThemeLabel(),
                  onTap: _showThemePicker,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ProfileMenuSection(
              title: LocaleKeys.support_tab.tr(),
              children: [
                ProfileMenuItem(
                  title: LocaleKeys.help_center.tr(),
                  icon: SolarLinearIcons.questionCircle,
                ),
                ProfileMenuItem(
                  title: LocaleKeys.privacy_policy.tr(),
                  icon: SolarLinearIcons.shieldKeyhole,
                ),
              ],
            ),
            const SizedBox(height: 30),
            LogoutButton(
              isLoading: isSigningOut,
              onTap: () => _onLogoutPressed(isSigningOut),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
