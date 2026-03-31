import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';
import '../widgets/auth_app_logo.dart';
import '../widgets/auth_back_scaffold.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_social_login_section.dart';
import '../widgets/auth_text_link_row.dart';
import '../widgets/login_form_fields_section.dart';

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

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignInSuccess) {
          AppSnackbar.showSuccess(
            context,
            LocaleKeys.auth_success_sign_in.tr(),
          );
          context.go(AppRouter.locationSetupPath);
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
                authState.operation == AuthOperation.signIn;

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
                LoginFormFieldsSection(
                  theme: theme,
                  isDark: isDark,
                  onForgotPassword: () =>
                      context.push(AppRouter.forgotPasswordPath),
                ),
                const SizedBox(height: 32),
                ReactiveFormConsumer(
                  builder: (context, form, child) => AuthPrimaryButton(
                    label: LocaleKeys.button_sign_in.tr(),
                    isLoading: isSubmitting,
                    onPressed: form.valid && !isSubmitting
                        ? () {
                            context.read<AuthCubit>().signIn(
                              email: (form.control('email').value as String)
                                  .trim(),
                              password:
                                  (form.control('password').value as String)
                                      .trim(),
                            );
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                const AuthSocialLoginSection(),
                const SizedBox(height: 32),
                AuthTextLinkRow(
                  prefixText: LocaleKeys.no_account.tr(),
                  linkText: LocaleKeys.sign_up_link.tr(),
                  onTap: () => context.push(AppRouter.authGatePath),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
