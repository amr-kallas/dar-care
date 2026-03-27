/// Represents a service department that a provider can belong to.
/// Maps to the `departments` table in the database.
class AppDepartment {
  const AppDepartment({required this.id, required this.name});

  /// Matches `departments.id`
  final String id;

  /// Display name shown in the dropdown
  final String name;

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppDepartment && other.id == id;

  @override
  int get hashCode => id.hashCode;

  /// Create from JSON (from Supabase)
  factory AppDepartment.fromJson(Map<String, dynamic> json) {
    return AppDepartment(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  /// Empty department for initialization
  static const empty = AppDepartment(id: '', name: '');
}
