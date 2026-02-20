import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  final String title;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // RTL Layout (Title on Right, Action on Left)
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: AppColors.brightGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
