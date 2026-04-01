import 'package:dar_care/features/chat/domain/entities/chat_entity.dart';
import 'package:dar_care/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<ChatEntity> getOrCreateChat({
    required String clientId,
    required String providerId,
  });

  Stream<List<MessageEntity>> getMessagesStream(String chatId);

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  });
}

