import 'package:dar_care/core/app/app_initializer.dart';
import 'package:dar_care/core/app/app_root.dart';
import 'package:dar_care/core/notifications/notification_bootstrap.dart';
import 'package:dar_care/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

/// Application entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  bootstrapNotifications();

  await runDarCareApp(const AppRoot());
}
