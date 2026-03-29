import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class LoginFormFieldsSection extends StatelessWidget {
  const LoginFormFieldsSection({
    super.key,
    required this.theme,
    required this.isDark,
    required this.onForgotPassword,
  });

  final ThemeData theme;
  final bool isDark;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReactiveTextField<String>(
          formControlName: 'email',
          decoration: InputDecoration(
            labelText: LocaleKeys.label_email.tr(),
            prefixIcon: const Icon(SolarLinearIcons.global),
          ),
          validationMessages: ValidationMessages.email,
        ),
        const SizedBox(height: 16),
        ReactiveTextField<String>(
          formControlName: 'password',
          obscureText: true,
          decoration: InputDecoration(
            labelText: LocaleKeys.label_password.tr(),
            prefixIcon: const Icon(SolarLinearIcons.shieldKeyhole),
          ),
          validationMessages: ValidationMessages.password,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onForgotPassword,
            child: Text(
              LocaleKeys.forgot_password.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        ReactiveCheckboxListTile(
          formControlName: 'rememberMe',
          title: Text(
            LocaleKeys.label_remember_me.tr(),
            style: theme.textTheme.bodyMedium,
          ),
          checkColor: isDark ? AppColors.deepDarkGreen : Colors.white,
          activeColor: AppColors.brightGreen,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
