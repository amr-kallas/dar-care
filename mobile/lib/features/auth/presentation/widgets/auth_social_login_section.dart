import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'social_login_button.dart';

/// Renders the "OR" divider and the Google / Apple social login buttons.
class AuthSocialLoginSection extends StatelessWidget {
  const AuthSocialLoginSection({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
  });

  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            LocaleKeys.or.tr(),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton(
              label: 'Google',
              icon: Icons.g_mobiledata,
              onPressed: onGooglePressed ?? () {},
            ),
            const SizedBox(width: 16),
            SocialLoginButton(
              label: 'Apple',
              icon: Icons.apple,
              onPressed: onApplePressed ?? () {},
            ),
          ],
        ),
      ],
    );
  }
}
