import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/otp_pin_input.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({
    super.key,
    this.phoneNumber = '+1 123 456 789',
  });

  final String? phoneNumber;

  FormGroup buildForm() => fb.group({
        'pin': ['', Validators.required, Validators.minLength(6)],
      });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ReactiveFormBuilder(
            form: buildForm,
            builder: (context, form, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.lock_open_rounded,
                    size: 80,
                    color: AppColors.brightGreen,
                  ),
                  const SizedBox(height: 32),

                  // ── Header ──
                  AuthHeader(
                    title: LocaleKeys.otp_verification_title.tr(),
                    subtitle: LocaleKeys.otp_verification_description
                        .tr(namedArgs: {'phoneNumber': phoneNumber ?? ''}),
                  ),
                  const SizedBox(height: 48),

                  // ── PIN input + inline error ──
                  const OtpPinInput(),
                  const SizedBox(height: 24),

                  // ── Submit ──
                  ReactiveFormConsumer(
                    builder: (context, form, child) => AuthPrimaryButton(
                      label: LocaleKeys.button_sign_in.tr(),
                      onPressed: form.valid ? () {
                         context.go(AppRouter.homePath);
                      } : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Resend code ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.didnt_receive_code.tr(),
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          LocaleKeys.resend_code.tr(),
                          style: const TextStyle(
                            color: AppColors.brightGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
