import 'package:dar_care/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size,
    this.strokeWidth = 4,
    this.padding,
  });

  final double? size;
  final double strokeWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth,
      color: isDark ? AppColors.brightGreen : AppColors.primaryDeepGreen,
    );

    if (size != null) {
      indicator = SizedBox(width: size, height: size, child: indicator);
    }

    if (padding != null) {
      indicator = Padding(padding: padding!, child: indicator);
    }

    return Center(child: indicator);
  }
}
