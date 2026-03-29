import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OtpResendRow extends StatelessWidget {
  const OtpResendRow({super.key, required this.isDark, required this.onResend});

  final bool isDark;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.didnt_receive_code.tr(),
          style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
        ),
        TextButton(
          onPressed: onResend,
          child: Text(
            LocaleKeys.resend_code.tr(),
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
