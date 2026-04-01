import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class ProfileThemeSheet extends StatelessWidget {
  const ProfileThemeSheet({
    super.key,
    required this.isDark,
    required this.currentThemeMode,
    required this.onThemeSelected,
  });

  final bool isDark;
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                LocaleKeys.theme_light.tr(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: currentThemeMode == ThemeMode.light
                  ? const Icon(
                      SolarLinearIcons.checkCircle,
                      color: AppColors.brightGreen,
                    )
                  : null,
              onTap: () => onThemeSelected(ThemeMode.light),
            ),
            ListTile(
              title: Text(
                LocaleKeys.theme_dark.tr(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: currentThemeMode == ThemeMode.dark
                  ? const Icon(
                      SolarLinearIcons.checkCircle,
                      color: AppColors.brightGreen,
                    )
                  : null,
              onTap: () => onThemeSelected(ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }
}
