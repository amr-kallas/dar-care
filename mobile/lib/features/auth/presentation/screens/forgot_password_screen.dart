import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_link_row.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  FormGroup buildForm() => fb.group({
        'email': ['', Validators.required, Validators.email],
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
                    Icons.lock_reset_rounded,
                    size: 80,
                    color: AppColors.brightGreen,
                  ),
                  const SizedBox(height: 32),

                  // ── Header ──
                  AuthHeader(
                    title: LocaleKeys.forgot_password_title.tr(),
                    subtitle: LocaleKeys.forgot_password_description.tr(),
                  ),
                  const SizedBox(height: 48),

                  // ── Email ──
                  ReactiveTextField<String>(
                    formControlName: 'email',
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_email.tr(),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validationMessages: ValidationMessages.email,
                  ),
                  const SizedBox(height: 32),

                  // ── Submit ──
                  ReactiveFormConsumer(
                    builder: (context, form, child) => AuthPrimaryButton(
                      label: LocaleKeys.button_send_reset_link.tr(),
                      onPressed: form.valid
                          ? () {
                              final email =
                                  form.control('email').value as String?;
                              context.push(
                                  AppRouter.otpVerificationPath,
                                  extra: email);
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Back to login ──
                  AuthTextLinkRow(
                    prefixText: LocaleKeys.back_to_login.tr(),
                    linkText: LocaleKeys.login.tr(),
                    onTap: () => context.pop(),
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
