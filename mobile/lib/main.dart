import 'package:dar_care/core/app/app_initializer.dart';
import 'package:dar_care/core/app/dar_care_app.dart';
import 'package:dar_care/core/services/notification_service.dart';
import 'package:dar_care/firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Application entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.registerBackgroundHandler();

  await runDarCareApp(
    // Enable device preview only in debug mode
    kDebugMode
        ? DevicePreview(enabled: true, builder: (context) => const DarCareApp())
        : const DarCareApp(),
  );
}
