import 'package:dar_care/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.clientId,
    required super.providerId,
    super.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final entity = ChatEntity.fromJson(json);
    return ChatModel(
      id: entity.id,
      clientId: entity.clientId,
      providerId: entity.providerId,
      createdAt: entity.createdAt,
    );
  }

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      clientId: entity.clientId,
      providerId: entity.providerId,
      createdAt: entity.createdAt,
    );
  }

}

