import 'package:dar_care/features/chat/presentation/cubit/chat_state.dart';
import 'package:dar_care/features/chat/presentation/widgets/message_bubble.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_cubit.dart';

class MessageListWidget extends StatelessWidget {
  final String currentUserId;

  const MessageListWidget({
    super.key,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading || state is ChatInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatError && state.messages.isEmpty) {
          return Center(
            child: Text(
              state.messageKey.tr(),
              textAlign: TextAlign.center,
            ),
          );
        }

        final messages = switch (state) {
          ChatLoaded loaded => loaded.messages,
          ChatMessageSending sending => sending.messages,
          ChatError error => error.messages,
          _ => const [],
        };

        if (messages.isEmpty) {
          return Center(child: Text(LocaleKeys.chat_no_messages.tr()));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: messages.length,
          separatorBuilder: (_, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final message = messages[index];
            return MessageBubble(
              message: message.message,
              isMine: message.senderId == currentUserId,
              timestamp: message.createdAt,
            );
          },
        );
      },
    );
  }
}
