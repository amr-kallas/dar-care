import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.showBackButton = true,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget? leadingWidget = leading;
    if (leadingWidget == null && showBackButton && Navigator.of(context).canPop()) {
      leadingWidget = IconButton(
        icon: Icon(
          SolarLinearIcons.altArrowLeft,
          color: isDark ? Colors.white : Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      );
    }

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      centerTitle: centerTitle,
      leading: leadingWidget,
      actions: actions,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: elevation,
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

