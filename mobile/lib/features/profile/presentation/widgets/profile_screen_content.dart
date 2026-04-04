import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/profile/presentation/widgets/logout_button.dart';
import 'package:dar_care/features/profile/presentation/widgets/profile_header.dart';
import 'package:dar_care/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:dar_care/features/profile/presentation/widgets/profile_menu_section.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({
    super.key,
    required this.user,
    required this.isSigningOut,
    required this.currentLanguageLabel,
    required this.currentThemeLabel,
    required this.onLanguageTap,
    required this.onThemeTap,
    required this.onLogoutTap,
  });

  final AuthUser? user;
  final bool isSigningOut;
  final String currentLanguageLabel;
  final String currentThemeLabel;
  final VoidCallback onLanguageTap;
  final VoidCallback onThemeTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                title: LocaleKeys.notifications.tr(),
                icon: SolarLinearIcons.bell,
                isPrimaryIcon: true,
                onTap: () => context.push(AppRouter.notificationsHistoryPath),
              ),
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
                trailingText: currentLanguageLabel,
                onTap: onLanguageTap,
              ),
              ProfileMenuItem(
                title: LocaleKeys.theme.tr(),
                icon: SolarLinearIcons.moon,
                isPrimaryIcon: true,
                trailingText: currentThemeLabel,
                onTap: onThemeTap,
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
          LogoutButton(isLoading: isSigningOut, onTap: onLogoutTap),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
