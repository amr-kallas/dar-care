import 'package:dar_care/core/utils/localized_db_text.dart';

/// Represents a service department that a provider can belong to.
/// Maps to the `departments` table in the database.
class AppDepartment {
  const AppDepartment({required this.id, required this.nameText});

  /// Matches `departments.id`
  final String id;

  /// Flexible name payload coming from Supabase (`{"ar","en"}` or plain text).
  final LocalizedDbText nameText;

  /// Backward-compatible default display value.
  String get name => nameText.defaultValue;

  /// Locale-aware name lookup with fallback support.
  String nameForLanguage(String languageCode) {
    return nameText.resolve(
      languageCode: languageCode,
      fallbackLanguageCode: 'en',
    );
  }

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
      nameText: LocalizedDbText.fromSupabase(json['name']),
    );
  }

  /// Empty department for initialization
  static const empty = AppDepartment(
    id: '',
    nameText: LocalizedDbText(plainText: ''),
  );
}
