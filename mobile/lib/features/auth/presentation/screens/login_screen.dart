import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_app_logo.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_social_login_section.dart';
import '../widgets/auth_text_link_row.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  FormGroup buildForm() => fb.group({
        'email': ['', Validators.required, Validators.email],
        'password': ['', Validators.required],
        'rememberMe': [false],
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                  const AuthAppLogo(),
                  const SizedBox(height: 48),
                  AuthHeader(
                    title: LocaleKeys.auth_journey_title.tr(),
                    subtitle: LocaleKeys.auth_login_subtitle.tr(),
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
                  const SizedBox(height: 16),

                  // ── Password ──
                  ReactiveTextField<String>(
                    formControlName: 'password',
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_password.tr(),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validationMessages: ValidationMessages.password,
                  ),

                  // ── Forgot password ──
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          context.push(AppRouter.forgotPasswordPath),
                      child: Text(
                        LocaleKeys.forgot_password.tr(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                  // ── Remember me ──
                  ReactiveCheckboxListTile(
                    formControlName: 'rememberMe',
                    title: Text(LocaleKeys.label_remember_me.tr(),
                        style: theme.textTheme.bodyMedium),
                    checkColor:
                        isDark ? AppColors.deepDarkGreen : Colors.white,
                    activeColor: AppColors.brightGreen,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),

                  // ── Submit ──
                  ReactiveFormConsumer(
                    builder: (context, form, child) => AuthPrimaryButton(
                      label: LocaleKeys.button_sign_in.tr(),
                      onPressed: form.valid
                          ? () => context.go(AppRouter.homePath)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Social login ──
                  const AuthSocialLoginSection(),
                  const SizedBox(height: 32),

                  // ── Sign-up link ──
                  AuthTextLinkRow(
                    prefixText: LocaleKeys.no_account.tr(),
                    linkText: LocaleKeys.sign_up_link.tr(),
                    onTap: () => context.push(AppRouter.signupPath),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
