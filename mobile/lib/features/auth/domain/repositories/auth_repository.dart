import 'package:dar_care/features/auth/domain/entities/auth_user.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Sign up a new user with email and password
  /// Returns [AuthUser] on success
  Future<AuthUser> signUpClient({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });

  /// Sign up a provider
  Future<AuthUser> signUpProvider({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required int departmentId,
    required int experienceYears,
    String? bio,
  });

  /// Sign in with email and password
  /// Returns [AuthUser] on success
  Future<AuthUser> signIn({required String email, required String password});

  /// Sign out the current user
  Future<void> signOut();

  /// Get the current authenticated user
  /// Returns null if not authenticated
  Future<AuthUser?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Reset password for email
  Future<void> resetPassword({required String email});

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  });

  /// Listen to authentication state changes
  Stream<AuthUser?> authStateChanges();
}
