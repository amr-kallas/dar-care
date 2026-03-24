import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/features/auth/data/models/app_department.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_app_logo.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_role_badge.dart';
import '../widgets/auth_section_header.dart';
import '../widgets/auth_social_login_section.dart';
import '../widgets/auth_text_link_row.dart';

class ProviderSignupScreen extends StatelessWidget {
  const ProviderSignupScreen({super.key});

  // ── Form definition ───────────────────────────────────────────────────────
  FormGroup buildForm() => fb.group({
        // Basic fields (mirror users table)
        'fullName': ['', Validators.required],
        'email': ['', Validators.required, Validators.email],
        'phoneNumber': [
          '',
          Validators.required,
          Validators.pattern(r'^[0-9]+$'),
        ],
        'password': ['', Validators.required, Validators.minLength(8)],
        // Professional fields (providers table)
        'department': [null, Validators.required],
        'experienceYears': [
          '',
          Validators.required,
          Validators.pattern(r'^[0-9]+$'),
        ],
        'bio': [''], // optional — no validators
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

                  // ── Brand logo ──
                  const AuthAppLogo(),
                  const SizedBox(height: 24),

                  // ── Header ──
                  AuthHeader(
                    title: LocaleKeys.auth_journey_title.tr(),
                    subtitle: LocaleKeys.auth_provider_signup_subtitle.tr(),
                  ),
                  const SizedBox(height: 16),

                  // ── Role badge ──
                  AuthRoleBadge(role: LocaleKeys.auth_professional_title.tr()),
                  const SizedBox(height: 28),

                  // ══════════════════════════════════════════════════════════
                  // SECTION 1 — Basic Information
                  // ══════════════════════════════════════════════════════════
                  AuthSectionHeader(
                      title: LocaleKeys.auth_provider_section_basic.tr()),
                  const SizedBox(height: 16),

                  // Full name
                  ReactiveTextField<String>(
                    formControlName: 'fullName',
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_full_name.tr(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validationMessages: ValidationMessages.fullName,
                  ),
                  const SizedBox(height: 16),

                  // Email
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

                  // Phone
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

                  // Password
                  ReactiveTextField<String>(
                    formControlName: 'password',
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_password.tr(),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validationMessages: ValidationMessages.password,
                  ),
                  const SizedBox(height: 28),

                  // ══════════════════════════════════════════════════════════
                  // SECTION 2 — Professional Details
                  // ══════════════════════════════════════════════════════════
                  AuthSectionHeader(
                      title:
                          LocaleKeys.auth_provider_section_professional.tr()),
                  const SizedBox(height: 16),

                  // Department dropdown  (maps to providers.department_id)
                  ReactiveDropdownField<AppDepartment>(
                    formControlName: 'department',
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_department.tr(),
                      prefixIcon: const Icon(Icons.build_outlined),
                      hintText: LocaleKeys.hint_department.tr(),
                    ),
                    items: AppDepartment.all
                        .map(
                          (d) => DropdownMenuItem(
                            value: d,
                            child: Text(d.name),
                          ),
                        )
                        .toList(),
                    validationMessages: ValidationMessages.department,
                  ),
                  const SizedBox(height: 16),

                  // Years of experience (maps to providers.experience_years)
                  ReactiveTextField<String>(
                    formControlName: 'experienceYears',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_experience_years.tr(),
                      prefixIcon: const Icon(Icons.workspace_premium_outlined),
                      hintText: LocaleKeys.hint_experience_years.tr(),
                    ),
                    validationMessages: ValidationMessages.experienceYears,
                  ),
                  const SizedBox(height: 16),

                  // Bio — optional, multiline
                  ReactiveTextField<String>(
                    formControlName: 'bio',
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.label_bio.tr(),
                      hintText: LocaleKeys.hint_bio.tr(),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.notes_outlined),
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Agree to terms
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

                  // ── Submit ──
                  ReactiveFormConsumer(
                    builder: (context, form, child) => AuthPrimaryButton(
                      label: LocaleKeys.button_sign_up.tr(),
                      onPressed: form.valid
                          ? () {
                              // TODO: dispatch provider registration event
                              // final data = form.value;
                              // role = 'provider' is set server-side
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
    );
  }
}

