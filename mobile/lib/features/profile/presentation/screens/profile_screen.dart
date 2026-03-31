import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/logout_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            const ProfileHeader(),
            const SizedBox(height: 30),
            const ProfileStats(),
            const SizedBox(height: 30),
            ProfileMenuSection(
              title: LocaleKeys.account_tab.tr(),
              children: [
                ProfileMenuItem(
                  title: LocaleKeys.edit_profile.tr(),
                  icon: SolarLinearIcons.pen,
                  isPrimaryIcon: true,
                ),
                ProfileMenuItem(
                  title: LocaleKeys.manage_addresses.tr(),
                  icon: SolarLinearIcons.mapPoint,
                  isPrimaryIcon: true,
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
                  trailingText: 'العربية',
                ),
                ProfileMenuItem(
                  title: LocaleKeys.notifications.tr(),
                  icon: SolarLinearIcons.bell,
                  isPrimaryIcon: true,
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
            const LogoutButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
