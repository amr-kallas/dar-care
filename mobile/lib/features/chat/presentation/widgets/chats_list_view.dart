import 'package:dar_care/features/chat/presentation/models/chat_list_item.dart';
import 'package:dar_care/features/chat/presentation/screens/chat_screen.dart';
import 'package:dar_care/features/chat/presentation/widgets/chat_list_item_tile.dart';
import 'package:flutter/material.dart';

class ChatsListView extends StatelessWidget {
  const ChatsListView({
    super.key,
    required this.chats,
    required this.currentUserId,
    required this.onRefresh,
  });

  final List<ChatListItem> chats;
  final String? currentUserId;
  final Future<void> Function() onRefresh;

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
            chat: chat,
            onTap: currentUserId == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          currentUserId: currentUserId!,
                          providerId: chat.providerUserId ?? chat.providerId,
                          title: chat.providerName,
                        ),
                      ),
                    );
                  },
          );
        },
      ),
    );
  }
}
