import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/theme/app_colors.dart';
import 'pin_error_text.dart';

/// A self-contained OTP pin input backed by a reactive form control named [formControlName].
/// Includes a themed [Pinput] and a [PinErrorText] below it.
class OtpPinInput extends StatelessWidget {
  const OtpPinInput({
    super.key,
    this.formControlName = 'pin',
    this.length = 6,
  });

  final String formControlName;
  final int length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

    return Column(
      children: [
        Center(
          child: ReactiveFormField<String, String>(
            formControlName: formControlName,
            builder: (field) {
              return Pinput(
                length: length,
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
            final control = form.control(formControlName);
            return PinErrorText(control: control);
          },
        ),
      ],
    );
  }
}

