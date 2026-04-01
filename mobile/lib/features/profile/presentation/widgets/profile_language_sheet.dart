import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/profile_preferences_utils.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class ProfileLanguageSheet extends StatelessWidget {
  const ProfileLanguageSheet({
    super.key,
    required this.isDark,
    required this.currentLanguageCode,
    required this.onLanguageSelected,
  });

  final bool isDark;
  final String currentLanguageCode;
  final ValueChanged<Locale> onLanguageSelected;

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
                LocaleKeys.language_english.tr(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing:
                  currentLanguageCode ==
                      ProfilePreferencesUtils.englishLocale.languageCode
                  ? const Icon(
                      SolarLinearIcons.checkCircle,
                      color: AppColors.brightGreen,
                    )
                  : null,
              onTap: () =>
                  onLanguageSelected(ProfilePreferencesUtils.englishLocale),
            ),
            ListTile(
              title: Text(
                LocaleKeys.language_arabic.tr(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing:
                  currentLanguageCode ==
                      ProfilePreferencesUtils.arabicLocale.languageCode
                  ? const Icon(
                      SolarLinearIcons.checkCircle,
                      color: AppColors.brightGreen,
                    )
                  : null,
              onTap: () =>
                  onLanguageSelected(ProfilePreferencesUtils.arabicLocale),
            ),
          ],
        ),
      ),
    );
  }
}
