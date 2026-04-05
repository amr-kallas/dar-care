import 'package:dar_care/core/widgets/app_primary_button.dart';
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
    return AppPrimaryButton(
      label: LocaleKeys.edit_profile.tr(),
      isLoading: isSaving,
      onPressed: isDisabled
          ? null
          : () async {
              await onPressed();
            },
    );
  }
}
