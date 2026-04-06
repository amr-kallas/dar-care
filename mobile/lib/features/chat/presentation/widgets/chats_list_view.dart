import 'package:dar_care/features/chat/data/models/chat_list_item.dart';
import 'package:dar_care/features/chat/presentation/widgets/chat_list_item_tile.dart';
import 'package:flutter/material.dart';

class ChatsListView extends StatelessWidget {
  const ChatsListView({
    super.key,
    required this.chats,
    required this.onRefresh,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.onTapBuilder,
  });

  final List<ChatListItem> chats;
  final Future<void> Function() onRefresh;
  final String Function(ChatListItem chat) titleBuilder;
  final String Function(ChatListItem chat) subtitleBuilder;
  final VoidCallback? Function(ChatListItem chat) onTapBuilder;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: chats.length,
        separatorBuilder: (_, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatListItemTile(
            title: titleBuilder(chat),
            subtitle: subtitleBuilder(chat),
            onTap: onTapBuilder(chat),
          );
        },
      ),
    );
  }
}
