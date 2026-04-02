import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AuthGateIntroSection extends StatelessWidget {
  const AuthGateIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          LocaleKeys.auth_gate_title.tr(),
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          LocaleKeys.auth_gate_subtitle.tr(),
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
