import 'package:dar_care/core/utils/localized_db_text.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final LocalizedDbText nameText;
  final LocalizedDbText descriptionText;
  final String? imageUrl;

  const CategoryModel({
    required this.id,
    required this.nameText,
    this.descriptionText = const LocalizedDbText(),
    this.imageUrl,
  });

  /// Backward-compatible default display value.
  String get name => nameText.defaultValue;

  /// Backward-compatible default description value.
  String? get description => descriptionText.isEmpty ? null : descriptionText.defaultValue;

  String localizedName(String languageCode) {
    return nameText.resolve(languageCode: languageCode, fallbackLanguageCode: 'en');
  }

  String? localizedDescription(String languageCode) {
    if (descriptionText.isEmpty) {
      return null;
    }
    return descriptionText.resolve(
      languageCode: languageCode,
      fallbackLanguageCode: 'en',
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      nameText: LocalizedDbText.fromSupabase(json['name']),
      descriptionText: LocalizedDbText.fromSupabase(json['description']),
      imageUrl: json['image_url'] as String?,
    );
  }

  // Helper to map DB names to Icons
  IconData get icon {
    final lowerName = nameText
        .resolve(languageCode: 'en', fallbackLanguageCode: 'ar')
        .toLowerCase();

    if (lowerName.contains('plumb')) return SolarLinearIcons.waterdrop;
    if (lowerName.contains('ac') || lowerName.contains('cool')) {
      return SolarLinearIcons.snowflake;
    }
    if (lowerName.contains('elec')) return SolarLinearIcons.bolt;
    if (lowerName.contains('clean')) return SolarLinearIcons.broom;
    if (lowerName.contains('carpen')) return SolarLinearIcons.sledgehammer;
    if (lowerName.contains('pest')) return SolarLinearIcons.bug;
    if (lowerName.contains('paint')) return SolarLinearIcons.paintRoller;
    return SolarLinearIcons.box; // Default icon
  }
}
