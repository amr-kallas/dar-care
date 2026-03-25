import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/features/auth/data/models/auth_user_model.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';

/// Abstract data source for authentication
abstract class AuthRemoteDataSource {
  /// Sign up a new user
  Future<AuthUserModel> signUpClient({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  /// Sign up a provider
  Future<AuthUserModel> signUpProvider({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required int departmentId,
    required int experienceYears,
    String? bio,
  });

  /// Sign in with email and password
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Get the current authenticated user from database
  Future<AuthUserModel?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Reset password
  Future<void> resetPassword({required String email});

  /// Update user profile in database
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  });

  /// Listen to authentication state changes
  Stream<AuthUserModel?> authStateChanges();
}

/// Implementation of AuthRemoteDataSource using Supabase
@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabaseClient = SupabaseService.client;
  final supabaseAuth = SupabaseService.auth;

  @override
  Future<AuthUserModel> signUpClient({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      // Sign up user with Supabase Auth
      final authResponse = await supabaseAuth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': UserRole.client.value,
          'phone': phone,
        },
      );

      if (authResponse.user == null) {
        throw Exception('Sign up failed: User is null');
      }

      // Create or update user profile in the users table
      await supabaseClient.from('users').upsert({
        'id': authResponse.user!.id,
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'role': UserRole.client.value,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Create client profile in the clients table
      await supabaseClient.from('clients').insert({
        'user_id': authResponse.user!.id,
      });

      return AuthUserModel.fromSupabaseUser(authResponse.user!);
    } catch (e) {
      log('Sign up error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthUserModel> signUpProvider({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required int departmentId,
    required int experienceYears,
    String? bio,
  }) async {
    try {
      // Sign up user with Supabase Auth
      final authResponse = await supabaseAuth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': UserRole.provider.value,
          'phone': phone,
          'department_id': departmentId,
          'experience_years': experienceYears,
          'bio': bio,
        },
      );

      if (authResponse.user == null) {
        throw Exception('Sign up failed: User is null');
      }

      // Create or update user profile in the users table
      await supabaseClient.from('users').upsert({
        'id': authResponse.user!.id,
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'role': UserRole.provider.value,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Create provider profile in the providers table
      await supabaseClient.from('providers').insert({
        'user_id': authResponse.user!.id,
        'department_id': departmentId,
        'experience_years': experienceYears,
        'bio': bio,
        'status': 'pending', // pending verification
      });

      return AuthUserModel.fromSupabaseUser(authResponse.user!);
    } catch (e) {
      log('Sign up error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await supabaseAuth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Sign in failed: User is null');
      }

      // Fetch user profile from users table
      final userProfile = await supabaseClient
          .from('users')
          .select()
          .eq('id', authResponse.user!.id)
          .single();

      return AuthUserModel.fromJson(userProfile);
    } catch (e) {
      log('Sign in error: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseAuth.signOut();
    } catch (e) {
      log('Sign out error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    try {
      final user = supabaseAuth.currentUser;
      if (user == null) return null;

      // Fetch user profile from users table
      final userProfile = await supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (userProfile == null) return null;

      return AuthUserModel.fromJson(userProfile);
    } catch (e) {
      log('Get current user error: $e');
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return supabaseAuth.currentUser != null;
    } catch (e) {
      log('Is authenticated error: $e');
      return false;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await supabaseAuth.resetPasswordForEmail(email);
    } catch (e) {
      log('Reset password error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (fullName != null) updateData['full_name'] = fullName;
      if (phone != null) updateData['phone'] = phone;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      await supabaseClient.from('users').update(updateData).eq('id', userId);
    } catch (e) {
      log('Update user profile error: $e');
      rethrow;
    }
  }

  @override
  Stream<AuthUserModel?> authStateChanges() {
    return supabaseAuth.onAuthStateChange.asyncMap((event) async {
      if (event.session?.user == null) return null;

      try {
        final userProfile = await supabaseClient
            .from('users')
            .select()
            .eq('id', event.session!.user.id)
            .maybeSingle();

        if (userProfile == null) return null;
        return AuthUserModel.fromJson(userProfile);
      } catch (e) {
        log('Auth state change error: $e');
        return null;
      }
    });
  }
}
