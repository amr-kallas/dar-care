import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      id: (json['id'] ?? '').toString(),
      chatId: (json['chat_id'] ?? '').toString(),
      senderId: (json['sender_id'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      isRead: (json['is_read'] as bool?) ?? false,
      createdAt:
          _parseDate(json['created_at']) ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
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
  List<Object?> get props => [id, chatId, senderId, message, isRead, createdAt];
}
