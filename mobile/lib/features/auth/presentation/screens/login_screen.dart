import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/social_login_button.dart';

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
                   const SizedBox(height: 20),
                   // Logo or Header
                   Center(
                     child: Column(
                       children: [
                         // Placeholder for small logo if needed
                         // Image.asset('assets/images/png/DareCareLogo.png', height: 60),
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
                   const SizedBox(height: 48),

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
                    LocaleKeys.auth_login_subtitle.tr(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Toggle Buttons (Login / Sign Up) - Visual Only or Functional if needed
                  // For now, this is Login Screen, so just show form.
                  
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
                    formControlName: 'password',
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_password.tr(),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validationMessages: ValidationMessages.password,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRouter.forgotPasswordPath),
                      child: Text(
                        LocaleKeys.forgot_password.tr(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  
                  // Terms checkbox if needed, or Remember Me
                  ReactiveCheckboxListTile(
                    formControlName: 'rememberMe',
                    title: Text(LocaleKeys.label_remember_me.tr(), style: theme.textTheme.bodyMedium),
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
                          onPressed: form.valid
                              ? () {
                                  // Verify login logic here
                                  context.go(AppRouter.homePath);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(LocaleKeys.button_sign_in.tr()),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Center(child: Text(LocaleKeys.or.tr(), style: const TextStyle(color: Colors.grey))),

                  const SizedBox(height: 24),

                  // Social Logins - Placeholders
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
                      Text(LocaleKeys.no_account.tr(), style: theme.textTheme.bodyMedium),
                      GestureDetector(
                        onTap: () => context.push(AppRouter.signupPath),
                        child: Text(
                          LocaleKeys.sign_up_link.tr(),
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
