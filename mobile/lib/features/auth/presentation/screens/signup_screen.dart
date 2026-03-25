import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_app_logo.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_social_login_section.dart';
import '../widgets/auth_text_link_row.dart';

/// Client (user) signup screen.
/// Role is always 'user' — provider registration uses [ProviderSignupScreen].
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  FormGroup buildForm() => fb.group({
        'fullName': ['', Validators.required],
        'email': ['', Validators.required, Validators.email],
        'phoneNumber': [
          '',
          Validators.required,
          Validators.pattern(r'^[0-9]+$'),
        ],
        'password': ['', Validators.required, Validators.minLength(8)],
        'agreeToTerms': [false, Validators.requiredTrue],
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpSuccess) {
          // Navigate to OTP via the new requirement
          // Pass the phone number to OTP screen if desirable, or null.
          final phone = context.read<AuthCubit>().state is AuthSignUpSuccess ?
            (context.read<AuthCubit>().state as AuthSignUpSuccess).user.phone : null;
          context.go(AppRouter.otpVerificationPath, extra: phone);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
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
                  const SizedBox(height: 10),
                  const AuthAppLogo(),
                  const SizedBox(height: 32),
                  AuthHeader(
                    title: LocaleKeys.auth_journey_title.tr(),
                    subtitle: LocaleKeys.auth_signup_subtitle.tr(),
                  ),
                  const SizedBox(height: 32),

                  // ── Full name ──
                  ReactiveTextField<String>(
                    formControlName: 'fullName',
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_full_name.tr(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validationMessages: ValidationMessages.fullName,
                  ),
                  const SizedBox(height: 16),

                  // ── Email ──
                  ReactiveTextField<String>(
                    formControlName: 'email',
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_email.tr(),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validationMessages: ValidationMessages.email,
                  ),
                  const SizedBox(height: 16),

                  // ── Phone ──
                  ReactiveTextField<String>(
                    formControlName: 'phoneNumber',
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_phone_number.tr(),
                      prefixIcon: const Icon(Icons.phone_outlined),
                      hintText: LocaleKeys.hint_phone_number.tr(),
                    ),
                    validationMessages: ValidationMessages.phoneNumber,
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
                  const SizedBox(height: 16),

                  // ── Terms ──
                  ReactiveCheckboxListTile(
                    formControlName: 'agreeToTerms',
                    title: Text(LocaleKeys.label_agree_terms.tr(),
                        style: theme.textTheme.bodyMedium),
                    checkColor:
                        isDark ? AppColors.deepDarkGreen : Colors.white,
                    activeColor: AppColors.brightGreen,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),

                  // ── Submit (role = 'user') ──
                  ReactiveFormConsumer(
                    builder: (context, form, child) => AuthPrimaryButton(
                      label: LocaleKeys.button_sign_up.tr(),
                      onPressed: form.valid
                          ? () {
                              context.read<AuthCubit>().signUpClient(
                                email: (form.control('email').value as String).trim(),
                                password: (form.control('password').value as String).trim(),
                                fullName: (form.control('fullName').value as String).trim(),
                                phone: (form.control('phoneNumber').value as String).trim(),
                              );
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Social login ──
                  const AuthSocialLoginSection(),
                  const SizedBox(height: 32),

                  // ── Login link ──
                  AuthTextLinkRow(
                    prefixText: LocaleKeys.have_account.tr(),
                    linkText: LocaleKeys.sign_in_alt.tr(),
                    onTap: () => context.push(AppRouter.loginPath),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    ),
);
  }
}
