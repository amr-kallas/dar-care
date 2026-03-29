import 'package:dar_care/core/utils/localized_db_text.dart';
import 'package:equatable/equatable.dart';

/// Domain entity representing a provider service department.
class Department extends Equatable {
  const Department({required this.id, required this.nameText});

  final String id;
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
  List<Object> get props => [id, nameText];

  @override
  String toString() => name;
}
