import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String clientId;
  final String providerId;
  final DateTime? createdAt;

  const ChatEntity({
    required this.id,
    required this.clientId,
    required this.providerId,
    this.createdAt,
  });

  factory ChatEntity.fromJson(Map<String, dynamic> json) {
    return ChatEntity(
      id: (json['id'] ?? '').toString(),
      clientId: (json['client_id'] ?? '').toString(),
      providerId: (json['provider_id'] ?? '').toString(),
      createdAt: _parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'provider_id': providerId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  @override
  List<Object?> get props => [id, clientId, providerId, createdAt];
}

