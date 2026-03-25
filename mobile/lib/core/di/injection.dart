import 'package:get_it/get_it.dart';
import 'injectable_config.dart' as di;

final getIt = GetIt.instance;

/// Initialize dependency injection with generated code
Future<void> configureDependencies() async {
  di.configureDependencies();
}
