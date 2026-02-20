import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/social_login_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key, this.role});

  final String? role; // Passed from AuthGate

  FormGroup buildForm() => fb.group({
        'fullName': ['', Validators.required],
        'email': ['', Validators.required, Validators.email],
        'phoneNumber': ['', Validators.required, Validators.pattern(r'^[0-9]+$')], // Basic pattern
        'password': ['', Validators.required, Validators.minLength(8)],
        'agreeToTerms': [false, Validators.requiredTrue],
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
                  // Logo or Header
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          LocaleKeys.app_name.tr(),
                          style: const TextStyle(
                            color: AppColors.brightGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    LocaleKeys.auth_journey_title.tr(),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.auth_signup_subtitle.tr(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Display selected role
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.brightGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.brightGreen),
                    ),
                    child: Text(
                      LocaleKeys.auth_join_as.tr(namedArgs: {'role': role ?? 'User'}),
                      style: const TextStyle(
                        color: AppColors.brightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 32),

                  ReactiveTextField<String>(
                    formControlName: 'fullName',
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_full_name.tr(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validationMessages: ValidationMessages.fullName,
                  ),
                  const SizedBox(height: 16),

                  ReactiveTextField<String>(
                    formControlName: 'email',
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_email.tr(),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validationMessages: ValidationMessages.email,
                  ),
                  const SizedBox(height: 16),

                  ReactiveTextField<String>(
                    formControlName: 'phoneNumber',
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: LocaleKeys.label_phone_number.tr(),
                        prefixIcon: const Icon(Icons.phone_outlined),
                        hintText: LocaleKeys.hint_phone_number.tr()
                    ),
                    validationMessages: ValidationMessages.phoneNumber,
                  ),
                  const SizedBox(height: 16),

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

                  // Privacy Policy Checkbox
                  ReactiveCheckboxListTile(
                    formControlName: 'agreeToTerms',
                    title: Text(LocaleKeys.label_agree_terms.tr(), style: theme.textTheme.bodyMedium),
                    checkColor: isDark ? AppColors.deepDarkGreen : Colors.white,
                    activeColor: AppColors.brightGreen,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 32),

                  ReactiveFormConsumer(
                    builder: (context, form, child) {
                      return SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: form.valid ? () {} : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(LocaleKeys.button_sign_up.tr()),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  Center(child: Text(LocaleKeys.or.tr(), style: const TextStyle(color: Colors.grey))),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(
                        label: 'Google',
                        icon: Icons.g_mobiledata,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      SocialLoginButton(
                        label: 'Apple',
                        icon: Icons.apple,
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(LocaleKeys.have_account.tr(), style: theme.textTheme.bodyMedium),
                      GestureDetector(
                        onTap: () => context.push(AppRouter.loginPath),
                        child: Text(
                          LocaleKeys.sign_in_alt.tr(),
                          style: const TextStyle(
                            color: AppColors.brightGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
