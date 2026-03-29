import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AuthTermsCheckbox extends StatelessWidget {
  const AuthTermsCheckbox({
    super.key,
    required this.theme,
    required this.isDark,
    this.formControlName = 'agreeToTerms',
  });

  final ThemeData theme;
  final bool isDark;
  final String formControlName;

  @override
  Widget build(BuildContext context) {
    return ReactiveCheckboxListTile(
      formControlName: formControlName,
      title: Text(
        LocaleKeys.label_agree_terms.tr(),
        style: theme.textTheme.bodyMedium,
      ),
      checkColor: isDark ? AppColors.deepDarkGreen : Colors.white,
      activeColor: AppColors.brightGreen,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
