import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  FormGroup buildForm() => fb.group({
        'email': ['', Validators.required, Validators.email],
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
                   Text(
                    LocaleKeys.forgot_password_title.tr(),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.forgot_password_description.tr(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  ReactiveTextField<String>(
                    formControlName: 'email',
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_email.tr(),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validationMessages: ValidationMessages.email,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  ReactiveFormConsumer(
                    builder: (context, form, child) {
                      return SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: form.valid
                              ? () {
                                  final email = form.control('email').value as String?;
                                  context.push(AppRouter.otpVerificationPath, extra: email);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(LocaleKeys.button_send_reset_link.tr()),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(LocaleKeys.back_to_login.tr(), style: TextStyle(color: isDark ? Colors.white70 : Colors.grey)),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          LocaleKeys.login.tr(),
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
