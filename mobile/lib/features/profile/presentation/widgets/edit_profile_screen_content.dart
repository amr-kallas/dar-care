import 'dart:typed_data';

import 'package:dar_care/features/profile/presentation/widgets/edit_profile_avatar_section.dart';
import 'package:dar_care/features/profile/presentation/widgets/edit_profile_fields_section.dart';
import 'package:dar_care/features/profile/presentation/widgets/edit_profile_submit_button.dart';
import 'package:flutter/material.dart';

class EditProfileScreenContent extends StatelessWidget {
  const EditProfileScreenContent({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.phoneController,
    required this.avatarUrl,
    required this.isSaving,
    required this.isUploadingAvatar,
    required this.isSubmitDisabled,
    required this.onAvatarCancelled,
    required this.onAvatarError,
    required this.onAvatarSelected,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final String? avatarUrl;
  final bool isSaving;
  final bool isUploadingAvatar;
  final bool isSubmitDisabled;
  final VoidCallback onAvatarCancelled;
  final ValueChanged<String> onAvatarError;
  final Future<void> Function(Uint8List bytes) onAvatarSelected;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EditProfileAvatarSection(
              imageUrl: avatarUrl,
              isUploadingAvatar: isUploadingAvatar,
              onCancelled: onAvatarCancelled,
              onError: onAvatarError,
              onImageSelected: onAvatarSelected,
            ),
            const SizedBox(height: 16),
            EditProfileFieldsSection(
              fullNameController: fullNameController,
              phoneController: phoneController,
            ),
            const SizedBox(height: 28),
            EditProfileSubmitButton(
              isSaving: isSaving,
              isDisabled: isSubmitDisabled,
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
