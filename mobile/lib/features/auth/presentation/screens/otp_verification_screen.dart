import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/pin_error_text.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key, this.phoneNumber = '+1 123 456 789'});

  final String? phoneNumber;

  FormGroup buildForm() => fb.group({
    'pin': ['', Validators.required, Validators.minLength(6)],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 20,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade300,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.brightGreen),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.errorRed),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
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
                  const Icon(
                    Icons.lock_open_rounded,
                    size: 80,
                    color: AppColors.brightGreen,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    LocaleKeys.otp_verification_title.tr(),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.otp_verification_description.tr(
                      namedArgs: {'phoneNumber': phoneNumber ?? ''},
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  Center(
                    child: ReactiveFormField<String, String>(
                      formControlName: 'pin',
                      builder: (field) {
                        return Pinput(
                          length: 6,
                          autofocus: true,
                          focusNode: field.focusNode,
                          onChanged: (value) => field.didChange(value),
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          errorPinTheme: errorPinTheme,
                          forceErrorState: field.errorText != null,
                        );
                      },
                    ),
                  ),

                  ReactiveFormConsumer(
                    builder: (context, form, child) {
                      final control = form.control('pin');
                      return PinErrorText(control: control);
                    },
                  ),

                  const SizedBox(height: 24),

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
                          child: Text(LocaleKeys.button_sign_in.tr()),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.didnt_receive_code.tr(),
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          LocaleKeys.resend_code.tr(),
                          style: const TextStyle(
                            color: AppColors.brightGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
