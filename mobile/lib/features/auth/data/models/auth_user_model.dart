import 'package:dar_care/features/auth/domain/entities/auth_user.dart';
import 'package:dar_care/features/auth/domain/entities/user_role.dart';

/// Data model for AuthUser with JSON serialization
class AuthUserModel extends AuthUser {
  AuthUserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.phone,
    super.address,
    required super.role,
    super.avatarUrl,
    required super.emailVerified,
    required super.createdAt,
  });

  /// Create from JSON (from Supabase)
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      role: UserRole.fromString(json['role'] as String? ?? 'client'),
      avatarUrl: json['avatar_url'] as String?,
      emailVerified: json['email_confirmed_at'] != null,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'address': address,
      'role': role.value,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create from Supabase User object
  factory AuthUserModel.fromSupabaseUser(dynamic supabaseUser) {
    final userMetadata =
        supabaseUser.userMetadata as Map<String, dynamic>? ?? {};
    return AuthUserModel(
      id: supabaseUser.id as String,
      email: supabaseUser.email as String,
      fullName: userMetadata['full_name'] as String?,
      phone: userMetadata['phone'] as String?,
      address: userMetadata['address'] as String?,
      role: UserRole.fromString(userMetadata['role'] as String? ?? 'client'),
      avatarUrl: userMetadata['avatar_url'] as String?,
      emailVerified: supabaseUser.emailConfirmedAt != null,
      createdAt: supabaseUser.createdAt != null
          ? DateTime.tryParse(supabaseUser.createdAt as String) ??
                DateTime.now()
          : DateTime.now(),
    );
  }
}
