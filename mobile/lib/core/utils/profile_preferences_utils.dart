import 'package:dar_care/core/theme/theme_controller.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class ProfilePreferencesUtils {
  static const Locale englishLocale = Locale('en');
  static const Locale arabicLocale = Locale('ar');

  static String currentLanguageLabel(BuildContext context) {
    return context.locale.languageCode == arabicLocale.languageCode
        ? LocaleKeys.language_arabic.tr()
        : LocaleKeys.language_english.tr();
  }

  static String currentThemeLabel() {
    return ThemeController.instance.isDarkMode
        ? LocaleKeys.theme_dark.tr()
        : LocaleKeys.theme_light.tr();
  }
}
