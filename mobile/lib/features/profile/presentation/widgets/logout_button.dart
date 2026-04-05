import 'package:dar_care/core/widgets/app_primary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import '../../../../generated/locale_keys.g.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const LogoutButton({
    super.key,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: LocaleKeys.logout.tr(),
      variant: AppButtonVariant.destructive,
      isLoading: isLoading,
      onPressed: isLoading ? null : onTap,
      icon: const Icon(SolarLinearIcons.logout, size: 20),
    );
  }
}
