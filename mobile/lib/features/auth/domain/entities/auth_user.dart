import 'package:dar_care/features/auth/domain/entities/user_role.dart';
import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user
class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? address;
  final UserRole role;
  final String? avatarUrl;
  final bool emailVerified;
  final DateTime createdAt;

  const AuthUser({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.address,
    required this.role,
    this.avatarUrl,
    required this.emailVerified,
    required this.createdAt,
  });

  /// Create a copy with modifications
  AuthUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? address,
    UserRole? role,
    String? avatarUrl,
    bool? emailVerified,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    phone,
    address,
    role,
    avatarUrl,
    emailVerified,
    createdAt,
  ];

  @override
  String toString() =>
      'AuthUser(id: $id, email: $email, role: ${role.displayName})';
}
