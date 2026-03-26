class ProviderModel {
  final int id;
  final String userId;
  final String fullName;
  final String profession;
  final double rating;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final double? hourlyRate;
  final int? experienceYears;
  final String? bio;

  const ProviderModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.profession,
    required this.rating,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.hourlyRate,
    this.experienceYears,
    this.bio,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    // Handling nested JSON from Supabase joins
    final userData = json['users'] as Map<String, dynamic>? ?? {};
    final departmentData = json['departments'] as Map<String, dynamic>? ?? {};

    return ProviderModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      fullName: userData['full_name'] as String? ?? 'Unknown Provider',
      profession: departmentData['name'] as String? ?? 'Service Provider',
      rating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String? ?? userData['avatar_url'] as String?,
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble(),
      experienceYears: json['experience_years'] as int?,
      bio: json['bio'] as String?,
      // Assuming lat/long might be in addresses later, for now null
    );
  }
}
