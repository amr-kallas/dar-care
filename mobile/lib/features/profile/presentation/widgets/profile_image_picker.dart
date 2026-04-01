import 'dart:typed_data';

import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    super.key,
    required this.imageUrl,
    required this.placeholder,
    required this.isLoading,
    required this.onImageSelected,
    required this.onCancelled,
    required this.onError,
    this.radius = 44,
  });

  final String? imageUrl;
  final ImageProvider<Object> placeholder;
  final bool isLoading;
  final Future<void> Function(Uint8List bytes) onImageSelected;
  final VoidCallback onCancelled;
  final ValueChanged<String> onError;
  final double radius;

  Future<void> _pickImage() async {
    try {
      final selected = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 1280,
      );
      if (selected == null) {
        onCancelled();
        return;
      }

      final bytes = await selected.readAsBytes();
      if (bytes.isEmpty) {
        onError(LocaleKeys.profile_image_read_error.tr());
        return;
      }

      await onImageSelected(bytes);
    } catch (_) {
      onError(LocaleKeys.profile_image_pick_error.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedImageUrl = imageUrl?.trim();
    final hasImage = resolvedImageUrl != null && resolvedImageUrl.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: isLoading ? null : _pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: hasImage
                ? NetworkImage(resolvedImageUrl)
                : placeholder,
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const AppLoadingIndicator(size: 24, strokeWidth: 2.5),
              ),
            ),
        ],
      ),
    );
  }
}
