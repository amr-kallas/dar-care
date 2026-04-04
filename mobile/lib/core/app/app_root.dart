import 'package:dar_care/core/app/dar_care_app.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Single app root that toggles tooling wrappers like DevicePreview.
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const DarCareApp();
    }

    return DevicePreview(
      enabled: true,
      builder: (context) => const DarCareApp(),
    );
  }
}

