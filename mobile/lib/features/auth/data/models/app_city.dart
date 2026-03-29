import 'package:dar_care/core/utils/localized_db_text.dart';

/// Represents a city option loaded from the `cities` table.
class AppCity {
  const AppCity({required this.id, required this.nameText});

  final String id;
  final LocalizedDbText nameText;

  String get name => nameText.defaultValue;

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
      identical(this, other) || other is AppCity && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory AppCity.fromJson(Map<String, dynamic> json) {
    return AppCity(
      id: json['id'] as String,
      nameText: LocalizedDbText.fromSupabase(json['name']),
    );
  }
}

