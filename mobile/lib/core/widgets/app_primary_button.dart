import 'package:dar_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, outline, destructive }

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final Widget? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final disabled = isLoading || onPressed == null;
    final action = disabled ? null : onPressed;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: switch (variant) {
        AppButtonVariant.outline => icon == null
            ? OutlinedButton(
                onPressed: action,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.borderDark
                        : AppColors.mediumGrey.withValues(alpha: 0.35),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _label(context),
              )
            : OutlinedButton.icon(
                onPressed: action,
                icon: icon!,
                label: _label(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.borderDark
                        : AppColors.mediumGrey.withValues(alpha: 0.35),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
        _ => icon == null
            ? ElevatedButton(
                onPressed: action,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _backgroundColor(context),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _backgroundColor(context).withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _label(context),
              )
            : ElevatedButton.icon(
                onPressed: action,
                icon: icon!,
                label: _label(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _backgroundColor(context),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _backgroundColor(context).withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
      },
    );
  }

  Widget _label(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Color _backgroundColor(BuildContext context) {
    return switch (variant) {
      AppButtonVariant.primary => AppColors.brightGreen,
      AppButtonVariant.destructive => AppColors.errorRed,
      AppButtonVariant.outline => Colors.transparent,
    };
  }
}
