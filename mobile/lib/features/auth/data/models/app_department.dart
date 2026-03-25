/// Represents a service department that a provider can belong to.
/// Maps to the `departments` table in the database.
class AppDepartment {
  const AppDepartment({required this.id, required this.name});

  /// Matches `departments.id`
  final int id;

  /// Display name shown in the dropdown
  final String name;

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppDepartment && other.id == id;

  @override
  int get hashCode => id.hashCode;

  /// Static list matching the app's service categories.
  /// Replace with an API call when the backend is ready.
  static const List<AppDepartment> all = [
    AppDepartment(id: 1, name: 'Plumbing'),
    AppDepartment(id: 2, name: 'AC & Cooling'),
    AppDepartment(id: 3, name: 'Electrical'),
    AppDepartment(id: 4, name: 'Cleaning'),
    AppDepartment(id: 5, name: 'Carpentry'),
    AppDepartment(id: 6, name: 'Pest Control'),
    AppDepartment(id: 7, name: 'Painting'),
  ];
}
