import 'package:dar_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'auth_header.dart';

class AuthIconHeaderBlock extends StatelessWidget {
  const AuthIconHeaderBlock({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 80, color: AppColors.brightGreen),
        const SizedBox(height: 32),
        AuthHeader(title: title, subtitle: subtitle),
      ],
    );
  }
}
