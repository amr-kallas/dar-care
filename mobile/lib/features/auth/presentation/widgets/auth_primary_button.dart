import 'package:dar_care/core/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';

/// A full-width primary action button used across auth screens.
/// Wraps [ReactiveFormConsumer] logic externally; accepts a plain [onPressed].
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      variant: AppButtonVariant.primary,
    );
  }
}
