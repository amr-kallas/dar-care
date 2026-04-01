import 'dart:typed_data';

import 'package:dar_care/features/profile/presentation/widgets/profile_image_picker.dart';
import 'package:dar_care/gen/assets.gen.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EditProfileAvatarSection extends StatelessWidget {
  const EditProfileAvatarSection({
    super.key,
    required this.imageUrl,
    required this.isUploadingAvatar,
    required this.onCancelled,
    required this.onError,
    required this.onImageSelected,
  });

  final String? imageUrl;
  final bool isUploadingAvatar;
  final VoidCallback onCancelled;
  final ValueChanged<String> onError;
  final Future<void> Function(Uint8List bytes) onImageSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ProfileImagePicker(
            imageUrl: imageUrl,
            placeholder: Assets.images.png.defaultAvatar.provider(),
            isLoading: isUploadingAvatar,
            onCancelled: onCancelled,
            onError: onError,
            onImageSelected: onImageSelected,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          LocaleKeys.profile_tap_image_to_change.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
