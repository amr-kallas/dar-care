import 'dart:core';

import 'package:dar_care/core/utils/localized_db_text.dart';

class ProviderModel {
  final String id;
  final String userId;
  final String fullName;
  final LocalizedDbText professionText;
  final double rating;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final double? hourlyRate;
  final int? experienceYears;
  final LocalizedDbText bioText;

  const ProviderModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.professionText,
    required this.rating,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.hourlyRate,
    this.experienceYears,
    this.bioText = const LocalizedDbText(),
  });

  /// Backward-compatible default profession value.
  String get profession => professionText.defaultValue;

  /// Backward-compatible default bio value.
  String? get bio => bioText.isEmpty ? null : bioText.defaultValue;

  String professionForLanguage(String languageCode) {
    return professionText.resolve(
      languageCode: languageCode,
      fallbackLanguageCode: 'en',
    );
  }

  String? bioForLanguage(String languageCode) {
    if (bioText.isEmpty) {
      return null;
    }
    return bioText.resolve(
      languageCode: languageCode,
      fallbackLanguageCode: 'en',
    );
  }

  bool matchesKeyword(String keyword) {
    final normalized = keyword.trim().toLowerCase();
    if (normalized.isEmpty) {
      return false;
    }

    return fullName.toLowerCase().contains(normalized) ||
        professionText.containsKeyword(normalized) ||
        bioText.containsKeyword(normalized);
  }

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    // Handling nested JSON from Supabase joins
    final dynamic rawUser = json['users'] ?? json['user'];
    Map<String, dynamic> userData = {};
    if (rawUser is List && rawUser.isNotEmpty) {
      userData = Map<String, dynamic>.from(rawUser.first as Map? ?? {});
    } else if (rawUser is Map) {
      userData = Map<String, dynamic>.from(rawUser);
    }

    final dynamic rawDept = json['departments'] ?? json['department'];
    Map<String, dynamic> departmentData = {};
    if (rawDept is List && rawDept.isNotEmpty) {
      departmentData = Map<String, dynamic>.from(rawDept.first as Map? ?? {});
    } else if (rawDept is Map) {
      departmentData = Map<String, dynamic>.from(rawDept);
    }

    final dynamic rawHourlyRate =
        json['hourly_rate'] ??
        json['hourlyRate'] ??
        json['hourly_price'] ??
        json['price_per_hour'];

    return ProviderModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      fullName:
          userData['full_name'] as String? ??
          userData['name'] as String? ??
          'Unknown Provider',
      professionText: LocalizedDbText.fromSupabase(
        departmentData['name'] ?? 'Service Provider',
      ),
      rating: ((json['avg_rating'] as num?) ?? 0.0).toDouble(),
      imageUrl: json['image_url'] as String?,
      hourlyRate: (rawHourlyRate as num?)?.toDouble(),
      experienceYears:
          json['experience_years'] as int? ?? json['experience'] as int?,
      bioText: LocalizedDbText.fromSupabase(json['bio']),
      // Assuming lat/long might be in addresses later, for now null
    );
  }
}
