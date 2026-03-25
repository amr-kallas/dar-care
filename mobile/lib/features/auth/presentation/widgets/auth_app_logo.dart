import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Displays the DarCare brand logo text centered on the auth screens.
class AuthAppLogo extends StatelessWidget {
  const AuthAppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.app_name.tr(),
        style: const TextStyle(
          color: AppColors.brightGreen,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
