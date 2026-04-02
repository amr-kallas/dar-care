import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import '../widgets/auth_back_scaffold.dart';
import '../widgets/auth_icon_header_block.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/otp_pin_input.dart';
import '../widgets/otp_resend_row.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key, this.phoneNumber});

  final String? phoneNumber;

  FormGroup buildForm() => fb.group({
    'pin': ['', Validators.required, Validators.minLength(6)],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthBackScaffold(
      child: ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              AuthIconHeaderBlock(
                icon: SolarLinearIcons.shieldKeyhole,
                title: LocaleKeys.otp_verification_title.tr(),
                subtitle: LocaleKeys.otp_verification_description.tr(
                  namedArgs: {
                    'phoneNumber':
                        (phoneNumber?.trim().isNotEmpty ?? false)
                            ? phoneNumber!.trim()
                            : LocaleKeys.otp_phone_placeholder.tr(),
                  },
                ),
              ),
              const SizedBox(height: 48),
              const OtpPinInput(),
              const SizedBox(height: 24),
              ReactiveFormConsumer(
                builder: (context, form, child) => AuthPrimaryButton(
                  label: LocaleKeys.button_sign_in.tr(),
                  onPressed: form.valid
                      ? () => context.go(AppRouter.locationSetupPath)
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              OtpResendRow(isDark: isDark, onResend: () {}),
            ],
          );
        },
      ),
    );
  }
}
