import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EditProfileSubmitButton extends StatelessWidget {
  const EditProfileSubmitButton({
    super.key,
    required this.isSaving,
    required this.isDisabled,
    required this.onPressed,
  });

  final bool isSaving;
  final bool isDisabled;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isDisabled
          ? null
          : () async {
              await onPressed();
            },
      child: isSaving
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(LocaleKeys.edit_profile.tr()),
    );
  }
}
