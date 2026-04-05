import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dar_care/core/errors/app_exceptions.dart';
import 'package:dar_care/core/services/supabase_service.dart';
import 'package:dar_care/features/auth/data/models/auth_user_model.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, FileOptions, SignOutScope;

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

  /// Upload avatar to storage and update profile image URL.
  Future<String> uploadAndUpdateAvatar({
    required String userId,
    required Uint8List fileBytes,
  });

  /// Listen to authentication state changes
  Stream<AuthUserModel?> authStateChanges();

  /// Persist push token for the current device in users table.
  Future<void> syncFcmToken({required String userId, String? fcmToken});
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
      final normalizedPhone = _normalizePhoneForPersistence(phone);

      // Sign up user with Supabase Auth
      final authResponse = await supabaseAuth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': UserRole.client.value,
          if (normalizedPhone != null) 'phone': normalizedPhone,
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
        'phone': normalizedPhone,
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
    _logProviderSignup(
      step: 'start',
      email: email,
      cityId: cityId,
      departmentId: departmentId,
      experienceYears: experienceYears,
    );

    try {
      String? departmentImageUrl;
      try {
        departmentImageUrl = await _getDepartmentImageUrl(departmentId);
        _logProviderSignup(
          step: 'department-image-loaded',
          email: email,
          departmentId: departmentId,
          details: departmentImageUrl == null ? 'image=none' : 'image=found',
        );
      } catch (error, stackTrace) {
        // Department image is optional for account creation.
        _logProviderSignup(
          step: 'department-image-failed',
          email: email,
          departmentId: departmentId,
          error: error,
          stackTrace: stackTrace,
        );
      }

      final normalizedPhone = _normalizePhoneForPersistence(phone);

      final authUser = await _signUpOrResumeProviderUser(
        email: email,
        password: password,
        fullName: fullName,
        phone: normalizedPhone,
        cityId: cityId,
        departmentId: departmentId,
        experienceYears: experienceYears,
        bio: bio,
      );

      _logProviderSignup(
        step: 'auth-user-ready',
        email: email,
        userId: authUser.id,
      );

      final userUpsertData = <String, dynamic>{
        'id': authUser.id,
        'email': email,
        'full_name': fullName,
        'phone': normalizedPhone,
        'role': UserRole.provider.value,
        'created_at': DateTime.now().toIso8601String(),
      };

      // Keep users upsert schema-safe: some environments do not have users.avatar_url.
      await supabaseClient.from('users').upsert(userUpsertData);
      _logProviderSignup(
        step: 'users-upsert-success',
        email: email,
        userId: authUser.id,
      );

      final providerUpsertData = <String, dynamic>{
        'user_id': authUser.id,
        'department_id': departmentId,
        'experience_years': experienceYears,
        'bio': bio,
        'status': 'pending',
      };
      if (departmentImageUrl != null) {
        providerUpsertData['image_url'] = departmentImageUrl;
      }

      final providerRow = await supabaseClient
          .from('providers')
          .upsert(providerUpsertData, onConflict: 'user_id')
          .select('id')
          .maybeSingle();

      _logProviderSignup(
        step: 'providers-upsert-success',
        email: email,
        userId: authUser.id,
        details: providerRow == null
            ? 'providerRow=null'
            : 'providerId=${providerRow['id']}',
      );

      if (providerRow != null && providerRow['id'] is String) {
        try {
          await _attachAddressToProvider(
            providerId: providerRow['id'] as String,
            cityId: cityId,
          );
          _logProviderSignup(
            step: 'provider-address-attached',
            email: email,
            userId: authUser.id,
            details: 'providerId=${providerRow['id']}',
          );
        } catch (error, stackTrace) {
          // Keep provider signup successful even if address linking fails.
          _logProviderSignup(
            step: 'provider-address-attach-failed',
            email: email,
            userId: authUser.id,
            error: error,
            stackTrace: stackTrace,
          );
        }
      }

      _logProviderSignup(
        step: 'completed',
        email: email,
        userId: authUser.id,
      );

      return AuthUserModel.fromSupabaseUser(authUser);
    } catch (error, stackTrace) {
      _logProviderSignup(
        step: 'failed',
        email: email,
        cityId: cityId,
        departmentId: departmentId,
        error: error,
        stackTrace: stackTrace,
      );
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
      await supabaseAuth.signOut().timeout(
        const Duration(seconds: 10),
        onTimeout: () async {
          // Fallback keeps app responsive even when token revocation is delayed.
          await supabaseAuth.signOut(scope: SignOutScope.local);
        },
      );
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
      if (phone != null) {
        updateData['phone'] = _normalizePhoneForPersistence(phone);
      }
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      if (updateData.isEmpty) {
        return;
      }

      await supabaseClient.from('users').update(updateData).eq('id', userId);

      if (avatarUrl != null) {
        await supabaseClient
            .from('providers')
            .update({'image_url': avatarUrl})
            .eq('user_id', userId);
        await supabaseClient
            .from('clients')
            .update({'image_url': avatarUrl})
            .eq('user_id', userId);
      }
    } catch (error, stackTrace) {
      throw DataAppException(
        'Failed to update profile.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<String> uploadAndUpdateAvatar({
    required String userId,
    required Uint8List fileBytes,
  }) async {
    try {
      final storagePath = 'users/$userId';
      final bucket = supabaseClient.storage.from('avatars');

      await bucket.uploadBinary(
        storagePath,
        fileBytes,
        fileOptions: const FileOptions(upsert: true),
      );

      final publicUrl = bucket.getPublicUrl(storagePath);

      await supabaseClient
          .from('providers')
          .update({'image_url': publicUrl})
          .eq('user_id', userId);

      await supabaseClient
          .from('clients')
          .update({'image_url': publicUrl})
          .eq('user_id', userId);

      // Keep existing user profile reads in sync with role-specific image URLs.
      await supabaseClient
          .from('users')
          .update({'avatar_url': publicUrl})
          .eq('id', userId);

      return publicUrl;
    } catch (error, stackTrace) {
      throw DataAppException(
        'Failed to upload avatar.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> syncFcmToken({required String userId, String? fcmToken}) async {
    try {
      await supabaseClient.from('users').update({
        'fcm_token': fcmToken,
        'fcm_token_updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (error, stackTrace) {
      throw DataAppException(
        'Failed to sync notification token.',
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

  Future<dynamic> _signUpOrResumeProviderUser({
    required String email,
    required String password,
    required String fullName,
    required String? phone,
    required String cityId,
    required String departmentId,
    required int experienceYears,
    String? bio,
  }) async {
    try {
      final authResponse = await supabaseAuth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': UserRole.provider.value,
          if (phone != null) 'phone': phone,
          'city_id': cityId,
          'department_id': departmentId,
          'experience_years': experienceYears,
          'bio': bio,
        },
      );

      if (authResponse.user == null) {
        throw const AuthAppException('Sign up failed. Please try again.');
      }

      return authResponse.user!;
    } on AuthException catch (error, stackTrace) {
      final message = error.message.toLowerCase();
      final isAlreadyRegistered =
          message.contains('already registered') ||
          message.contains('already been registered') ||
          message.contains('user already exists');
      final isDatabaseErrorSavingUser =
          message.contains('database error saving new user');

      // Some projects have strict auth trigger casting rules (often around phone).
      // Retry once with minimal metadata so auth user creation can proceed.
      if (isDatabaseErrorSavingUser && phone != null) {
        _logProviderSignup(
          step: 'auth-signup-retry-minimal-metadata',
          email: email,
          details: 'reason=database-error-saving-new-user',
        );

        try {
          final retryAuthResponse = await supabaseAuth.signUp(
            email: email,
            password: password,
            data: {
              'full_name': fullName,
              'role': UserRole.provider.value,
            },
          );

          if (retryAuthResponse.user != null) {
            return retryAuthResponse.user!;
          }
        } on AuthException {
          // Keep original error handling below to preserve user-facing behavior.
        }
      }

      if (!isAlreadyRegistered) {
        if (isDatabaseErrorSavingUser) {
          throw AuthAppException(
            'Could not create account due to server profile validation. Please verify the phone format and try again.',
            cause: error,
            stackTrace: stackTrace,
          );
        }

        throw AuthAppException(
          'Auth signup failed: ${error.message}',
          cause: error,
          stackTrace: stackTrace,
        );
      }

      final signInResponse = await supabaseAuth.signInWithPassword(
        email: email,
        password: password,
      );

      if (signInResponse.user == null) {
        throw const AuthAppException(
          'Email is already registered. Please sign in instead.',
        );
      }

      return signInResponse.user!;
    }
  }

  Future<String?> _getDepartmentImageUrl(String departmentId) async {
    final department = await supabaseClient
        .from('departments')
        .select('image_url')
        .eq('id', departmentId)
        .maybeSingle();

    if (department == null) {
      return null;
    }

    final imageUrl = department['image_url'] as String?;
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return null;
    }

    return imageUrl.trim();
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
    log(
      '[AuthRemoteDataSource] $fallbackMessage | ${error.runtimeType}: $error',
      stackTrace: stackTrace,
    );

    if (error is AppException && error is AuthAppException) {
      return error;
    }

    return AuthAppException(
      fallbackMessage,
      cause: error,
      stackTrace: stackTrace,
    );
  }

  void _logProviderSignup({
    required String step,
    String? email,
    String? userId,
    String? cityId,
    String? departmentId,
    int? experienceYears,
    String? details,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final context = <String>[
      'step=$step',
      if (email != null) 'email=${_maskEmail(email)}',
      if (userId != null) 'userId=$userId',
      if (cityId != null) 'cityId=$cityId',
      if (departmentId != null) 'departmentId=$departmentId',
      if (experienceYears != null) 'experienceYears=$experienceYears',
      if (details != null && details.isNotEmpty) details,
      if (error != null) 'errorType=${error.runtimeType}',
      if (error != null) 'error=$error',
    ].join(' | ');

    log('[ProviderSignup] $context', stackTrace: stackTrace);
  }

  String _maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex <= 1) {
      return '***';
    }

    final namePart = email.substring(0, atIndex);
    final domainPart = email.substring(atIndex);

    if (namePart.length <= 2) {
      return '${namePart[0]}***$domainPart';
    }

    return '${namePart.substring(0, 2)}***$domainPart';
  }

  String? _normalizePhoneForPersistence(String? phone) {
    final trimmed = phone?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    final digitsOnly = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      return null;
    }

    return digitsOnly;
  }
}
