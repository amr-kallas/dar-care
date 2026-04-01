import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/core/widgets/app_snackbar.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:dar_care/features/auth/presentation/cubit/auth/auth_state.dart';
import 'package:dar_care/features/profile/presentation/widgets/profile_image_picker.dart';
import 'package:dar_care/gen/assets.gen.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

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

  AuthUser? _getCurrentUser(AuthState state) {
    if (state is AuthAuthenticated) return state.user;
    if (state is AuthSignInSuccess) return state.user;
    if (state is AuthSignUpSuccess) return state.user;
    return null;
  }

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
          final user = _getCurrentUser(authState);
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
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ProfileImagePicker(
                        imageUrl: _currentAvatarUrl,
                        placeholder: Assets.images.png.defaultAvatar.provider(),
                        isLoading: isUploadingAvatar,
                        onCancelled: () {
                          AppSnackbar.showError(context, 'Image selection canceled');
                        },
                        onError: (message) {
                          AppSnackbar.showError(context, message);
                        },
                        onImageSelected: (bytes) async {
                          if (user == null) return;
                          _isAvatarFlow = true;
                          await context.read<AuthCubit>().uploadAndUpdateAvatar(
                            userId: user.id,
                            fileBytes: bytes,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap image to change',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _fullNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.label_full_name.tr(),
                        prefixIcon: const Icon(SolarLinearIcons.user),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.validation_required_name.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.label_phone_number.tr(),
                        prefixIcon: const Icon(SolarLinearIcons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.validation_required_phone.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed:
                          (user == null || isSaving || isUploadingAvatar)
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  final fullName = _fullNameController.text
                                      .trim();
                                  final phone = _phoneController.text.trim();
                                  final noTextChanges =
                                      fullName ==
                                          (user.fullName ?? '').trim() &&
                                      phone == (user.phone ?? '').trim();

                                  if (noTextChanges) {
                                    context.pop();
                                    return;
                                  }

                                  if (!context.mounted) return;
                                  _didSubmit = true;
                                  context.read<AuthCubit>().updateProfile(
                                    userId: user.id,
                                    fullName: fullName,
                                    phone: phone,
                                  );
                                },
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(LocaleKeys.edit_profile.tr()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
