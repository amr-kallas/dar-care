import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/utils/auth_state_user_resolver.dart';
import 'package:dar_care/core/utils/profile_edit_actions_helper.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/profile/presentation/widgets/edit_profile_screen_content.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _didInit = false;
  bool _didSubmit = false;
  bool _isAvatarFlow = false;

  String? _currentAvatarUrl;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (_isAvatarFlow) {
            _isAvatarFlow = false;
            setState(() {
              _currentAvatarUrl = state.user.avatarUrl;
            });
          }

          if (_didSubmit) {
            _didSubmit = false;
            AppSnackbar.showSuccess(context, LocaleKeys.edit_profile.tr());
            context.pop();
          }
        } else if (state is AuthError) {
          if (_didSubmit || _isAvatarFlow) {
            _didSubmit = false;
            _isAvatarFlow = false;
            AppSnackbar.showError(context, state.messageKey.tr());
          }
        }
      },
      child: Builder(
        builder: (context) {
          final authState = context.watch<AuthCubit>().state;
          final user = resolveAuthUser(authState);
          final isSaving =
              authState is AuthLoading &&
              authState.operation == AuthOperation.updateProfile;
          final isUploadingAvatar =
              authState is AuthLoading &&
              authState.operation == AuthOperation.uploadAvatar;

          if (!_didInit) {
            _fullNameController.text = user?.fullName ?? '';
            _phoneController.text = user?.phone ?? '';
            _currentAvatarUrl = user?.avatarUrl;
            _didInit = true;
          }

          return Scaffold(
            backgroundColor: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            appBar: CustomAppBar(
              titleWidget: Text(
                LocaleKeys.edit_profile.tr(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: EditProfileScreenContent(
              formKey: _formKey,
              fullNameController: _fullNameController,
              phoneController: _phoneController,
              avatarUrl: _currentAvatarUrl,
              isSaving: isSaving,
              isUploadingAvatar: isUploadingAvatar,
              isSubmitDisabled: user == null || isSaving || isUploadingAvatar,
              onAvatarCancelled: () {
                AppSnackbar.showError(
                  context,
                  LocaleKeys.profile_image_selection_canceled.tr(),
                );
              },
              onAvatarError: (message) {
                AppSnackbar.showError(context, message);
              },
              onAvatarSelected: (bytes) async {
                await ProfileEditActionsHelper.uploadAvatar(
                  context: context,
                  user: user,
                  bytes: bytes,
                  onAvatarFlowStarted: () {
                    _isAvatarFlow = true;
                  },
                );
              },
              onSubmit: () async {
                await ProfileEditActionsHelper.submitProfileChanges(
                  context: context,
                  user: user,
                  formKey: _formKey,
                  fullNameController: _fullNameController,
                  phoneController: _phoneController,
                  onSubmitStarted: () {
                    _didSubmit = true;
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
