import 'package:dar_care/core/app/app_initializer.dart';
import 'package:dar_care/core/app/dar_care_app.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

/// Application entry point
void main() => runDarCareApp(
  // Enable dee vice preview only in debug mode
  kDebugMode
      ? DevicePreview(enabled: true, builder: (context) => const DarCareApp())
      : const DarCareApp(),
);
