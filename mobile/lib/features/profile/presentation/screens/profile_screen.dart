import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/scheduler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/utils/auth_state_user_resolver.dart';
import '../../../../core/utils/profile_preferences_utils.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth/auth_state.dart';
import '../widgets/profile_language_sheet.dart';
import '../widgets/profile_screen_content.dart';
import '../widgets/profile_theme_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _requestedSessionCheck = false;

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
        return ProfileLanguageSheet(
          isDark: isDark,
          currentLanguageCode: currentLanguageCode,
          onLanguageSelected: (locale) async {
            if (currentLanguageCode != locale.languageCode) {
              await context.setLocale(locale);
            }
            if (mounted) Navigator.of(bottomSheetContext).pop();
          },
        );
      },
    );
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
        return ProfileThemeSheet(
          isDark: isDark,
          currentThemeMode: currentThemeMode,
          onThemeSelected: (mode) async {
            await ThemeController.instance.setThemeMode(mode);
            if (mounted) Navigator.of(bottomSheetContext).pop();
          },
        );
      },
    );
  }

  Future<void> _onLogoutPressed(bool isSigningOut) async {
    if (isSigningOut) return;

    final shouldLogout = await showAppConfirmationDialog(
      context: context,
      title: LocaleKeys.logout_confirm_title.tr(),
      message: LocaleKeys.logout_confirm_message.tr(),
      confirmText: LocaleKeys.confirm.tr(),
      cancelText: LocaleKeys.cancel.tr(),
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
        authState is AuthLoading &&
        authState.operation == AuthOperation.signOut;
    final user = resolveAuthUser(authState);
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
      body: ProfileScreenContent(
        user: user,
        isSigningOut: isSigningOut,
        currentLanguageLabel: ProfilePreferencesUtils.currentLanguageLabel(
          context,
        ),
        currentThemeLabel: ProfilePreferencesUtils.currentThemeLabel(),
        onLanguageTap: _showLanguagePicker,
        onThemeTap: _showThemePicker,
        onLogoutTap: () => _onLogoutPressed(isSigningOut),
      ),
    );
  }
}
