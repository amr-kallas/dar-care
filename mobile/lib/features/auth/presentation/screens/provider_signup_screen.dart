import 'package:dar_care/core/di/injectable_config.dart';
import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/features/auth/data/models/app_department.dart';
import 'package:dar_care/features/auth/presentation/cubit/department_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/department_state.dart';
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
import '../widgets/auth_role_badge.dart';
import '../widgets/auth_section_header.dart';
import '../widgets/auth_social_login_section.dart';
import '../widgets/auth_text_link_row.dart';
import 'package:dar_care/core/widgets/app_loading_indicator.dart';

class ProviderSignupScreen extends StatelessWidget {
  const ProviderSignupScreen({super.key});

  // ── Form definition ───────────────────────────────────────────────────────
  FormGroup buildForm() => fb.group({
    // Basic fields (mirror users table)
    'fullName': fb.control<String>('', [Validators.required]),
    'email': fb.control<String>('', [Validators.required, Validators.email]),
    'phoneNumber': fb.control<String>('', [
      Validators.required,
      Validators.pattern(r'^[0-9]+$'),
    ]),
    'password': fb.control<String>('', [
      Validators.required,
      Validators.minLength(8),
    ]),
    // Professional fields (providers table)
    'department': fb.control<AppDepartment?>(null, [Validators.required]),
    'experienceYears': fb.control<String>('', [
      Validators.required,
      Validators.pattern(r'^[0-9]+$'),
    ]),
    'bio': fb.control<String>(''), // optional
    'agreeToTerms': fb.control<bool>(false, [Validators.requiredTrue]),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => getIt<DepartmentCubit>()..loadDepartments(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            final phone = context.read<AuthCubit>().state is AuthSignUpSuccess
                ? (context.read<AuthCubit>().state as AuthSignUpSuccess)
                      .user
                      .phone
                : null;
            context.go(AppRouter.otpVerificationPath, extra: phone);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black,
              ),
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
                      AuthRoleBadge(
                        role: LocaleKeys.auth_professional_title.tr(),
                      ),
                      const SizedBox(height: 28),

                      // ══════════════════════════════════════════════════════════
                      // SECTION 1 — Basic Information
                      // ══════════════════════════════════════════════════════════
                      AuthSectionHeader(
                        title: LocaleKeys.auth_provider_section_basic.tr(),
                      ),
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
                        title: LocaleKeys.auth_provider_section_professional
                            .tr(),
                      ),
                      const SizedBox(height: 16),

                      // Department dropdown  (maps to providers.department_id)
                      BlocBuilder<DepartmentCubit, DepartmentState>(
                        builder: (context, state) {
                          if (state is DepartmentLoading) {
                            return const AppLoadingIndicator(
                              padding: EdgeInsets.all(8),
                              size: 24,
                              strokeWidth: 3,
                            );
                          } else if (state is DepartmentLoaded) {
                            return ReactiveDropdownField<AppDepartment?>(
                              formControlName: 'department',
                              decoration: InputDecoration(
                                labelText: LocaleKeys.label_department.tr(),
                                prefixIcon: const Icon(Icons.build_outlined),
                                hintText: LocaleKeys.hint_department.tr(),
                              ),
                              items: state.departments
                                  .map(
                                    (d) => DropdownMenuItem<AppDepartment?>(
                                      value: d,
                                      child: Text(d.name),
                                    ),
                                  )
                                  .toList(),
                              validationMessages: ValidationMessages.department,
                            );
                          } else if (state is DepartmentError) {
                            return Text(
                              'Error loading departments: ${state.message}',
                              style: const TextStyle(color: Colors.red),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 16),

                      // Years of experience (maps to providers.experience_years)
                      ReactiveTextField<String>(
                        formControlName: 'experienceYears',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.label_experience_years.tr(),
                          prefixIcon: const Icon(
                            Icons.workspace_premium_outlined,
                          ),
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
                        title: Text(
                          LocaleKeys.label_agree_terms.tr(),
                          style: theme.textTheme.bodyMedium,
                        ),
                        checkColor: isDark
                            ? AppColors.deepDarkGreen
                            : Colors.white,
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
                                  final department =
                                      form.control('department').value
                                          as AppDepartment;
                                  context.read<AuthCubit>().signUpProvider(
                                    email:
                                        (form.control('email').value as String)
                                            .trim(),
                                    password:
                                        (form.control('password').value
                                                as String)
                                            .trim(),
                                    fullName:
                                        (form.control('fullName').value
                                                as String)
                                            .trim(),
                                    phone:
                                        (form.control('phoneNumber').value
                                                as String)
                                            .trim(),
                                    departmentId: department.id,
                                    experienceYears: int.parse(
                                      (form.control('experienceYears').value
                                              as String)
                                          .trim(),
                                    ),
                                    bio: form.control('bio').value != null
                                        ? (form.control('bio').value as String)
                                              .trim()
                                        : null,
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
      ),
    );
  }
}
