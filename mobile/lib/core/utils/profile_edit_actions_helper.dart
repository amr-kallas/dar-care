import 'dart:typed_data';

import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileEditActionsHelper {
  static Future<void> submitProfileChanges({
    required BuildContext context,
    required AuthUser? user,
    required GlobalKey<FormState> formKey,
    required TextEditingController fullNameController,
    required TextEditingController phoneController,
    required VoidCallback onSubmitStarted,
  }) async {
    if (user == null) return;

    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }

    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final noTextChanges =
        fullName == (user.fullName ?? '').trim() &&
        phone == (user.phone ?? '').trim();

    if (noTextChanges) {
      context.pop();
      return;
    }

    if (!context.mounted) return;
    onSubmitStarted();
    context.read<AuthCubit>().updateProfile(
      userId: user.id,
      fullName: fullName,
      phone: phone,
    );
  }

  static Future<void> uploadAvatar({
    required BuildContext context,
    required AuthUser? user,
    required Uint8List bytes,
    required VoidCallback onAvatarFlowStarted,
  }) async {
    if (user == null) return;

    onAvatarFlowStarted();
    await context.read<AuthCubit>().uploadAndUpdateAvatar(
      userId: user.id,
      fileBytes: bytes,
    );
  }
}
