import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PinErrorText extends StatelessWidget {
  const PinErrorText({
    super.key,
    required this.control,
  });

  final AbstractControl<dynamic> control;

  String _getPinError() {
    if (control.touched && control.hasError('required')) {
      return 'Please enter the verification code.';
    } else if (control.touched && control.hasError('minLength')) {
      return 'The code must be 6 digits long.';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final errorText = _getPinError();

    if (errorText.isEmpty) {
      return const SizedBox(height: 24);
    }

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
