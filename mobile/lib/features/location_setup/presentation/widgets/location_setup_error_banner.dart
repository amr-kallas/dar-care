import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocationSetupErrorBanner extends StatelessWidget {
  const LocationSetupErrorBanner({super.key, required this.errorKey});

  final String errorKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.red.shade50,
      padding: const EdgeInsets.all(12),
      child: Text(errorKey.tr(), style: TextStyle(color: Colors.red.shade900)),
    );
  }
}
