import 'package:dar_care/core/utils/chat_presentation_utils.dart';
import 'package:dar_care/features/chat/data/models/chat_list_item.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_empty_state.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_error_state.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_list_view.dart';
import 'package:flutter/material.dart';

class ChatsOverviewBody extends StatelessWidget {
  const ChatsOverviewBody({
    super.key,
    required this.chatsFuture,
    required this.onRefresh,
    required this.resolveDisplayName,
    required this.onTapBuilder,
  });

  final Future<List<ChatListItem>> chatsFuture;
  final Future<void> Function() onRefresh;
  final String Function(ChatListItem chat) resolveDisplayName;
  final VoidCallback? Function(ChatListItem chat) onTapBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatListItem>>(
      future: chatsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ChatsErrorState(onRetry: onRefresh);
        }

        final chats = snapshot.data ?? const <ChatListItem>[];
        if (chats.isEmpty) {
          return ChatsEmptyState(onRefresh: onRefresh);
        }

        return ChatsListView(
          chats: chats,
          onRefresh: onRefresh,
          titleBuilder: resolveDisplayName,
          subtitleBuilder: (chat) => formatChatStartedAt(chat.createdAt),
          onTapBuilder: onTapBuilder,
        );
      },
    );
  }
}

