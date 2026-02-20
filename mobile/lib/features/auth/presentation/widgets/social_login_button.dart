import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100, // Fixed width for uniformity
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
        child: Icon(icon, color: isDark ? Colors.white : Colors.black),
      ),
    );
  }
}
