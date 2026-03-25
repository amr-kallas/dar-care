import 'package:flutter/material.dart';

/// A reusable screen header showing a [title] and an optional [subtitle].
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleFontSize = 28,
  });

  final String title;
  final String? subtitle;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
