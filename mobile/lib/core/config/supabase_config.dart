import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration constants loaded from .env file
class SupabaseConfig {
  SupabaseConfig._();

  /// Get Supabase URL from environment variables
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception(
        'SUPABASE_URL is not set in .env file. '
        'Please copy .env.example to .env and add your Supabase credentials.',
      );
    }
    return url;
  }

  /// Get Supabase anonymous key from environment variables
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception(
        'SUPABASE_ANON_KEY is not set in .env file. '
        'Please copy .env.example to .env and add your Supabase credentials.',
      );
    }
    return key;
  }

  /// Get app environment
  static String get appEnv {
    return dotenv.env['APP_ENV'] ?? 'development';
  }

  /// Check if running in development mode
  static bool get isDevelopment {
    return appEnv == 'development';
  }
}

