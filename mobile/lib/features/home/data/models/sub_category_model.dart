import 'package:dar_care/core/utils/localized_db_text.dart';

class SubCategoryModel {
  final String id;
  final String departmentId;
  final LocalizedDbText nameText;
  final LocalizedDbText descriptionText;

  const SubCategoryModel({
    required this.id,
    required this.departmentId,
    required this.nameText,
    this.descriptionText = const LocalizedDbText(),
  });

  String localizedName(String languageCode) {
    return nameText.resolve(
      languageCode: languageCode,
      fallbackLanguageCode: 'en',
    );
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

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] as String,
      departmentId: json['department_id'] as String,
      nameText: LocalizedDbText.fromSupabase(json['name']),
      descriptionText: LocalizedDbText.fromSupabase(json['description']),
    );
  }
}
