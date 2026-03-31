import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/features/auth/data/models/app_city.dart';
import 'package:dar_care/features/auth/data/repositories/city_repository.dart';
import 'package:dar_care/features/auth/presentation/models/auth_registration_data.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';
import '../widgets/auth_app_logo.dart';
import '../widgets/auth_back_scaffold.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_social_login_section.dart';
import '../widgets/auth_terms_checkbox.dart';
import '../widgets/auth_text_link_row.dart';
import '../widgets/signup_basic_fields_section.dart';

/// Client (user) signup screen.
/// Role is always 'user' — provider registration uses [ProviderSignupScreen].
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key, this.registrationData});

  final AuthRegistrationData? registrationData;

  FormGroup buildForm() => fb.group({
    'fullName': ['', Validators.required],
    'email': ['', Validators.required, Validators.email],
    'phoneNumber': ['', Validators.required, Validators.pattern(r'^[0-9]+$')],
    'city': fb.control<AppCity?>(null, [Validators.required]),
    'password': ['', Validators.required, Validators.minLength(8)],
    'agreeToTerms': [false, Validators.requiredTrue],
  });

  Future<List<AppCity>> _loadCities() async {
    if (registrationData != null) {
      return registrationData!.cities;
    }
    return CityRepository().getCities();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FutureBuilder<List<AppCity>>(
      future: _loadCities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AuthBackScaffold(child: AppLoadingIndicator());
        }

        if (snapshot.hasError) {
          return AuthBackScaffold(
            child: Center(
              child: Text(
                LocaleKeys.auth_error_cities_failed.tr(),
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final cities = snapshot.data ?? <AppCity>[];

        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSignUpSuccess) {
              AppSnackbar.showSuccess(
                context,
                LocaleKeys.auth_success_sign_up.tr(),
              );
              context.go(
                AppRouter.otpVerificationPath,
                extra: state.user.phone,
              );
            } else if (state is AuthError) {
              AppSnackbar.showError(context, state.messageKey.tr());
            }
          },
          child: AuthBackScaffold(
            child: ReactiveFormBuilder(
              form: buildForm,
              builder: (context, form, child) {
                final authState = context.watch<AuthCubit>().state;
                final isSubmitting =
                    authState is AuthLoading &&
                    authState.operation == AuthOperation.signUp;

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
                    SignupBasicFieldsSection(cities: cities),
                    const SizedBox(height: 16),
                    AuthTermsCheckbox(theme: theme, isDark: isDark),
                    const SizedBox(height: 32),
                    ReactiveFormConsumer(
                      builder: (context, form, child) => AuthPrimaryButton(
                        label: LocaleKeys.button_sign_up.tr(),
                        isLoading: isSubmitting,
                        onPressed: form.valid && !isSubmitting
                            ? () {
                                final city =
                                    form.control('city').value as AppCity;
                                context.read<AuthCubit>().signUpClient(
                                  email: (form.control('email').value as String)
                                      .trim(),
                                  password:
                                      (form.control('password').value as String)
                                          .trim(),
                                  fullName:
                                      (form.control('fullName').value as String)
                                          .trim(),
                                  phone:
                                      (form.control('phoneNumber').value
                                              as String)
                                          .trim(),
                                  cityId: city.id,
                                );
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const AuthSocialLoginSection(),
                    const SizedBox(height: 32),
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
        );
      },
    );
  }
}
