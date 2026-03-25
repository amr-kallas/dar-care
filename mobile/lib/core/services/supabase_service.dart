import 'dart:developer';

import 'package:dar_care/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase service initialization
class SupabaseService {
  SupabaseService._();

  /// Initialize Supabase client
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );

      // Log successful initialization in development mode
      if (SupabaseConfig.isDevelopment) {
        log('✓ Supabase initialized successfully');
        log('URL: ${SupabaseConfig.supabaseUrl}');
      }
    } catch (e) {
      log('✗ Failed to initialize Supabase: $e');
      rethrow;
    }
  }

  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Get authentication instance
  static GoTrueClient get auth => Supabase.instance.client.auth;

  /// Get database instance (RealtimeClient)
  static RealtimeClient get realtime => Supabase.instance.client.realtime;
}

