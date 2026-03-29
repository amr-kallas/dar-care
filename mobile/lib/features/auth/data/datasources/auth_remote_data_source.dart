import 'dart:developer';

import 'package:dar_care/core/errors/app_exceptions.dart';
import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/features/auth/data/models/auth_user_model.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:injectable/injectable.dart';

/// Abstract data source for authentication
abstract class AuthRemoteDataSource {
  /// Sign up a new user
  Future<AuthUserModel> signUpClient({
    required String email,
    required String password,
    required String fullName,
    required String cityId,
    String? phone,
  });

  /// Sign up a provider
  Future<AuthUserModel> signUpProvider({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cityId,
    required String departmentId,
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
    required String cityId,
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
          'city_id': cityId,
        },
      );

      if (authResponse.user == null) {
        throw const AuthAppException('Sign up failed. Please try again.');
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

      // Create client profile and attach an address carrying the selected city.
      final insertedClient = await supabaseClient
          .from('clients')
          .insert({'user_id': authResponse.user!.id})
          .select('id')
          .single();

      await _attachAddressToClient(
        clientId: insertedClient['id'] as String,
        cityId: cityId,
      );

      return AuthUserModel.fromSupabaseUser(authResponse.user!);
    } catch (error, stackTrace) {
      throw _mapAuthException(
        error,
        stackTrace,
        fallbackMessage: 'Failed to create account. Please try again.',
      );
    }
  }

  @override
  Future<AuthUserModel> signUpProvider({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cityId,
    required String departmentId,
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
          'city_id': cityId,
          'department_id': departmentId,
          'experience_years': experienceYears,
          'bio': bio,
        },
      );

      if (authResponse.user == null) {
        throw const AuthAppException('Sign up failed. Please try again.');
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

      // Create provider profile and attach an address carrying the selected city.
      final insertedProvider = await supabaseClient
          .from('providers')
          .insert({
            'user_id': authResponse.user!.id,
            'department_id': departmentId,
            'experience_years': experienceYears,
            'bio': bio,
            'status': 'pending',
          })
          .select('id')
          .single();

      await _attachAddressToProvider(
        providerId: insertedProvider['id'] as String,
        cityId: cityId,
      );

      return AuthUserModel.fromSupabaseUser(authResponse.user!);
    } catch (error, stackTrace) {
      throw _mapAuthException(
        error,
        stackTrace,
        fallbackMessage: 'Failed to create provider account. Please try again.',
      );
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
        throw const AuthAppException('Sign in failed. Please try again.');
      }

      // Fetch user profile from users table
      final userProfile = await supabaseClient
          .from('users')
          .select()
          .eq('id', authResponse.user!.id)
          .single();

      return AuthUserModel.fromJson(userProfile);
    } catch (error, stackTrace) {
      throw _mapAuthException(
        error,
        stackTrace,
        fallbackMessage: 'Invalid credentials or server error.',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseAuth.signOut();
    } catch (error, stackTrace) {
      throw _mapAuthException(
        error,
        stackTrace,
        fallbackMessage: 'Failed to sign out. Please try again.',
      );
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
    } catch (error, stackTrace) {
      throw DataAppException(
        'Failed to load current user.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return supabaseAuth.currentUser != null;
    } catch (error, stackTrace) {
      throw DataAppException(
        'Failed to validate session.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await supabaseAuth.resetPasswordForEmail(email);
    } catch (error, stackTrace) {
      throw _mapAuthException(
        error,
        stackTrace,
        fallbackMessage: 'Failed to send reset link. Please try again.',
      );
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
    } catch (error, stackTrace) {
      throw DataAppException(
        'Failed to update profile.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _attachAddressToClient({
    required String clientId,
    required String cityId,
  }) async {
    final insertedAddress = await supabaseClient
        .from('addresses')
        .insert({
          'client_id': clientId,
          'city_id': cityId,
          'details': 'Signup city',
          'location_updated_at': DateTime.now().toIso8601String(),
        })
        .select('id')
        .single();

    await supabaseClient
        .from('clients')
        .update({'address_id': insertedAddress['id']})
        .eq('id', clientId);
  }

  Future<void> _attachAddressToProvider({
    required String providerId,
    required String cityId,
  }) async {
    final insertedAddress = await supabaseClient
        .from('addresses')
        .insert({
          'provider_id': providerId,
          'city_id': cityId,
          'details': 'Signup city',
          'location_updated_at': DateTime.now().toIso8601String(),
        })
        .select('id')
        .single();

    await supabaseClient
        .from('providers')
        .update({'address_id': insertedAddress['id']})
        .eq('id', providerId);
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
      } catch (error, stackTrace) {
        log('Auth state change error: $error', stackTrace: stackTrace);
        return null;
      }
    });
  }

  AuthAppException _mapAuthException(
    Object error,
    StackTrace stackTrace, {
    required String fallbackMessage,
  }) {
    if (error is AppException && error is AuthAppException) {
      return error;
    }

    return AuthAppException(
      fallbackMessage,
      cause: error,
      stackTrace: stackTrace,
    );
  }
}
