import 'package:dar_care/core/theme/app_colors.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class FavoritesErrorState extends StatelessWidget {
  const FavoritesErrorState({
    super.key,
    required this.messageKey,
    required this.onRetry,
  });

  final String? messageKey;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              SolarLinearIcons.dangerCircle,
              color: AppColors.errorRed,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              (messageKey?.trim().isNotEmpty ?? false)
                  ? messageKey!.tr()
                  : LocaleKeys.favorites_error_generic.tr(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await onRetry();
              },
              child: Text(LocaleKeys.favorites_retry_button.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
