import 'package:flutter/material.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

/// Shared scaffold for auth screens with back arrow and padded scrollable body.
class AuthBackScaffold extends StatelessWidget {
  const AuthBackScaffold({
    super.key,
    required this.child,
    this.horizontalPadding = 24,
  });

  final Widget child;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            SolarLinearIcons.altArrowLeft,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: child,
        ),
      ),
    );
  }
}
