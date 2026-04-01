import 'package:dar_care/features/chat/domain/entities/chat_entity.dart';
import 'package:dar_care/features/chat/domain/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final ChatEntity chat;
  final List<MessageEntity> messages;

  const ChatLoaded({required this.chat, required this.messages});

  @override
  List<Object?> get props => [chat, messages];
}

class ChatMessageSending extends ChatState {
  final ChatEntity chat;
  final List<MessageEntity> messages;

  const ChatMessageSending({required this.chat, required this.messages});

  @override
  List<Object?> get props => [chat, messages];
}

class ChatError extends ChatState {
  final String message;
  final ChatEntity? chat;
  final List<MessageEntity> messages;

  const ChatError({required this.message, this.chat, this.messages = const []});

  @override
  List<Object?> get props => [message, chat, messages];
}

