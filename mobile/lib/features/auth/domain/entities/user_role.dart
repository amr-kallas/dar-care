/// User role enumeration
enum UserRole {
  client('client'),
  provider('provider');

  final String value;
  const UserRole(this.value);

  /// Convert string to UserRole
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.value == role,
      orElse: () => UserRole.client,
    );
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case UserRole.client:
        return 'Client';
      case UserRole.provider:
        return 'Service Provider';
    }
  }
}

