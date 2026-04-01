import 'package:dar_care/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:dar_care/features/chat/domain/entities/chat_entity.dart';
import 'package:dar_care/features/chat/domain/entities/message_entity.dart';
import 'package:dar_care/features/chat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<ChatEntity> getOrCreateChat({
    required String clientId,
    required String providerId,
  }) {
    return _remoteDataSource.getOrCreateChat(
      clientId: clientId,
      providerId: providerId,
    );
  }

  @override
  Stream<List<MessageEntity>> getMessagesStream(String chatId) {
    return _remoteDataSource.getMessagesStream(chatId);
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) {
    return _remoteDataSource.sendMessage(
      chatId: chatId,
      senderId: senderId,
      text: text,
    );
  }
}

