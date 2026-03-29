import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

enum AppSnackbarType { success, error, info }

/// Global floating feedback banner (without using Material SnackBar widget).
class AppSnackbar {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void showSuccess(BuildContext context, String message) {
    _show(context: context, message: message, type: AppSnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context: context, message: message, type: AppSnackbarType.error);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context: context, message: message, type: AppSnackbarType.info);
  }

  static void hide() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }

  static void _show({
    required BuildContext context,
    required String message,
    required AppSnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    hide();

    _entry = OverlayEntry(
      builder: (context) => _AppSnackbarBanner(message: message, type: type),
    );

    overlay.insert(_entry!);
    _timer = Timer(duration, hide);
  }
}

class _AppSnackbarBanner extends StatelessWidget {
  const _AppSnackbarBanner({required this.message, required this.type});

  final String message;
  final AppSnackbarType type;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 12;
    final colors = _colors(
      type,
      Theme.of(context).brightness == Brightness.dark,
    );

    return Positioned(
      top: top,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 220),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, -14 * (1 - value)),
                child: child,
              ),
            );
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(_icon(type), color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static IconData _icon(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return SolarLinearIcons.clipboardList;
      case AppSnackbarType.error:
        return SolarLinearIcons.dangerCircle;
      case AppSnackbarType.info:
        return SolarLinearIcons.bell;
    }
  }

  static List<Color> _colors(AppSnackbarType type, bool isDark) {
    switch (type) {
      case AppSnackbarType.success:
        return isDark
            ? const [Color(0xFF0F5D4A), Color(0xFF138A6B)]
            : const [Color(0xFF169A74), Color(0xFF22B184)];
      case AppSnackbarType.error:
        return isDark
            ? const [Color(0xFF7A1F2A), Color(0xFF9C2D3A)]
            : const [Color(0xFFC63C4C), Color(0xFFE34C5E)];
      case AppSnackbarType.info:
        return isDark
            ? const [Color(0xFF224A78), Color(0xFF2F6297)]
            : const [Color(0xFF3A7CC2), Color(0xFF4C90DA)];
    }
  }
}
