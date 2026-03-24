import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A row with a plain [prefixText] and a tappable [linkText] in green.
/// Used for "Don't have an account? Sign Up" style rows.
class AuthTextLinkRow extends StatelessWidget {
  const AuthTextLinkRow({
    super.key,
    required this.prefixText,
    required this.linkText,
    required this.onTap,
  });

  final String prefixText;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prefixText, style: Theme.of(context).textTheme.bodyMedium),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: AppColors.brightGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

