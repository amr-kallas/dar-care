import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/role_card.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Header
              Text(
                LocaleKeys.auth_gate_title.tr(),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.auth_gate_subtitle.tr(),
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // User Card
              RoleCard(
                title: LocaleKeys.auth_user_title.tr(),
                description: LocaleKeys.auth_user_description.tr(),
                icon: Icons.person_outline,
                buttonText: LocaleKeys.auth_user_button.tr(),
                onPressed: () {
                  context.push(AppRouter.signupPath);
                },
              ),

              const SizedBox(height: 24),

              // Professional Card
              RoleCard(
                title: LocaleKeys.auth_professional_title.tr(),
                description: LocaleKeys.auth_professional_description.tr(),
                icon: Icons.handyman_outlined,
                buttonText: LocaleKeys.auth_professional_button.tr(),
                onPressed: () {
                  context.push(AppRouter.providerSignupPath);
                },
              ),

              const SizedBox(height: 48),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.have_account.tr(),
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRouter.loginPath),
                    child: Text(
                      LocaleKeys.sign_in_link.tr(),
                      style: const TextStyle(
                        color: AppColors.brightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
