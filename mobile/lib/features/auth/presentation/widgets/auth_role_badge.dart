import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Displays the selected role as a pill badge on the signup screen.
class AuthRoleBadge extends StatelessWidget {
  const AuthRoleBadge({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.brightGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.brightGreen),
      ),
      child: Text(
        LocaleKeys.auth_join_as.tr(namedArgs: {'role': role}),
        style: const TextStyle(
          color: AppColors.brightGreen,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
