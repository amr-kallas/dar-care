import 'package:flutter/material.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';

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
    return Scaffold(
      appBar: const CustomAppBar(
        backgroundColor: Colors.transparent,
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
