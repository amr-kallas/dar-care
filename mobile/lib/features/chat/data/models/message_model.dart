import 'package:dar_care/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.message,
    required super.isRead,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final entity = MessageEntity.fromJson(json);
    return MessageModel(
      id: entity.id,
      chatId: entity.chatId,
      senderId: entity.senderId,
      message: entity.message,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      chatId: entity.chatId,
      senderId: entity.senderId,
      message: entity.message,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }

}

