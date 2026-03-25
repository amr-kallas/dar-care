import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../core/utils/validation_messages.dart';

class PinErrorText extends StatelessWidget {
  const PinErrorText({super.key, required this.control});

  final AbstractControl<dynamic> control;

  String _getPinError() {
    if (control.touched && control.hasError('required')) {
      return ValidationMessages.otp['required']!(control.getError('required')!);
    } else if (control.touched && control.hasError('minLength')) {
      return ValidationMessages.otp['minLength']!(
        control.getError('minLength')!,
      );
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final errorText = _getPinError();

    if (errorText.isEmpty) return const SizedBox(height: 24);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        errorText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }
}
