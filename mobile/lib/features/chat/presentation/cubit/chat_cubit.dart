import 'dart:async';

import 'package:dar_care/features/chat/domain/entities/chat_entity.dart';
import 'package:dar_care/features/chat/domain/entities/message_entity.dart';
import 'package:dar_care/features/chat/domain/repositories/chat_repository.dart';
import 'package:dar_care/features/chat/presentation/cubit/chat_state.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;
  ChatEntity? _currentChat;
  List<MessageEntity> _messages = const [];

  ChatCubit(this._chatRepository) : super(const ChatInitial());

  Future<void> initializeChat({
    required String clientId,
    required String providerId,
  }) async {
    emit(const ChatLoading());

    try {
      final chat = await _chatRepository.getOrCreateChat(
        clientId: clientId,
        providerId: providerId,
      );

      _currentChat = chat;
      await _subscribeToMessages(chat.id);
      emit(ChatLoaded(chat: chat, messages: _messages));
    } catch (error, stackTrace) {
      debugPrint('Chat initialize failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      emit(const ChatError(messageKey: LocaleKeys.chat_error_initialize));
    }
  }

  Future<void> sendMessage({
    required String senderId,
    required String text,
  }) async {
    final chat = _currentChat;
    if (chat == null) {
      emit(const ChatError(messageKey: LocaleKeys.chat_error_not_initialized));
      return;
    }

    final normalizedText = text.trim();
    if (normalizedText.isEmpty) {
      return;
    }

    emit(ChatMessageSending(chat: chat, messages: _messages));

    try {
      await _chatRepository.sendMessage(
        chatId: chat.id,
        senderId: senderId,
        text: normalizedText,
      );
      emit(ChatLoaded(chat: chat, messages: _messages));
    } catch (_) {
      emit(
        ChatError(
          messageKey: LocaleKeys.chat_error_send,
          chat: chat,
          messages: _messages,
        ),
      );
      emit(ChatLoaded(chat: chat, messages: _messages));
    }
  }

  Future<void> _subscribeToMessages(String chatId) async {
    await _messagesSubscription?.cancel();
    _messagesSubscription = _chatRepository.getMessagesStream(chatId).listen(
      (messages) {
        final sortedMessages = List<MessageEntity>.from(messages)
          ..sort((a, b) {
            final byTime = a.createdAt.compareTo(b.createdAt);
            if (byTime != 0) {
              return byTime;
            }
            return a.id.compareTo(b.id);
          });

        _messages = List<MessageEntity>.unmodifiable(sortedMessages);
        final chat = _currentChat;
        if (chat != null) {
          emit(ChatLoaded(chat: chat, messages: _messages));
        }
      },
      onError: (error, stackTrace) {
        debugPrint('Chat receive stream failed: $error');
        debugPrintStack(stackTrace: stackTrace);
        emit(
          ChatError(
            messageKey: LocaleKeys.chat_error_receive,
            chat: _currentChat,
            messages: _messages,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    return super.close();
  }
}
