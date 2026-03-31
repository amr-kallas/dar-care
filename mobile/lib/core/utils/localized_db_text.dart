import 'dart:convert';

import 'package:dar_care/core/config/localization_config.dart';

/// Handles Supabase text columns that can be either:
/// - localized JSON objects: {"ar": "...", "en": "..."}
/// - plain user-entered strings
class LocalizedDbText {
  const LocalizedDbText({
    this.plainText,
    this.translations = const <String, String>{},
  });

  final String? plainText;
  final Map<String, String> translations;

  factory LocalizedDbText.fromSupabase(dynamic raw) {
    if (raw == null) {
      return const LocalizedDbText();
    }

    if (raw is Map) {
      final map = <String, String>{
        for (final entry in raw.entries)
          if (entry.key != null && entry.value != null)
            entry.key.toString(): entry.value.toString(),
      };
      return LocalizedDbText(translations: map);
    }

    if (raw is String) {
      final parsedMap = _tryParseJsonObject(raw);
      if (parsedMap != null) {
        return LocalizedDbText(translations: parsedMap);
      }
      return LocalizedDbText(plainText: raw);
    }

    return LocalizedDbText(plainText: raw.toString());
  }

  static Map<String, String>? _tryParseJsonObject(String value) {
    final trimmed = value.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return null;
    }

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map) {
        return null;
      }

      return <String, String>{
        for (final entry in decoded.entries)
          if (entry.key != null && entry.value != null)
            entry.key.toString(): entry.value.toString(),
      };
    } catch (_) {
      return null;
    }
  }

  bool get isEmpty {
    if ((plainText ?? '').trim().isNotEmpty) {
      return false;
    }

    return !translations.values.any((value) => value.trim().isNotEmpty);
  }

  String resolve({
    required String languageCode,
    String fallbackLanguageCode = 'en',
    String emptyValue = '',
  }) {
    final languageValue = (translations[languageCode] ?? '').trim();
    if (languageValue.isNotEmpty) {
      return languageValue;
    }

    final fallbackValue = (translations[fallbackLanguageCode] ?? '').trim();
    if (fallbackValue.isNotEmpty) {
      return fallbackValue;
    }

    for (final value in translations.values) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }

    final plain = (plainText ?? '').trim();
    return plain.isNotEmpty ? plain : emptyValue;
  }

  String get defaultValue => resolve(
    languageCode: LocalizationConfig.fallbackLocale.languageCode,
    fallbackLanguageCode: 'en',
  );

  Iterable<String> get searchableValues sync* {
    final plain = (plainText ?? '').trim();
    if (plain.isNotEmpty) {
      yield plain;
    }

    for (final value in translations.values) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        yield trimmed;
      }
    }
  }

  bool containsKeyword(String keyword) {
    final needle = keyword.trim().toLowerCase();
    if (needle.isEmpty) {
      return false;
    }

    return searchableValues.any(
      (value) => value.toLowerCase().contains(needle),
    );
  }
}
