import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/core/utils/validation_messages.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../widgets/auth_back_scaffold.dart';
import '../widgets/auth_icon_header_block.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_link_row.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  FormGroup buildForm() => fb.group({
    'email': ['', Validators.required, Validators.email],
  });

  @override
  Widget build(BuildContext context) {
    return AuthBackScaffold(
      child: ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              AuthIconHeaderBlock(
                icon: SolarLinearIcons.shieldKeyhole,
                title: LocaleKeys.forgot_password_title.tr(),
                subtitle: LocaleKeys.forgot_password_description.tr(),
              ),
              const SizedBox(height: 48),
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: InputDecoration(
                  labelText: LocaleKeys.label_email.tr(),
                  prefixIcon: const Icon(SolarLinearIcons.global),
                ),
                validationMessages: ValidationMessages.email,
              ),
              const SizedBox(height: 32),
              ReactiveFormConsumer(
                builder: (context, form, child) => AuthPrimaryButton(
                  label: LocaleKeys.button_send_reset_link.tr(),
                  onPressed: form.valid
                      ? () {
                          final email = form.control('email').value as String?;
                          context.push(
                            AppRouter.otpVerificationPath,
                            extra: email,
                          );
                        }
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              AuthTextLinkRow(
                prefixText: LocaleKeys.back_to_login.tr(),
                linkText: LocaleKeys.login.tr(),
                onTap: () => context.pop(),
              ),
            ],
          );
        },
      ),
    );
  }
}
