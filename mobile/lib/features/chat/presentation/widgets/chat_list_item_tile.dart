import 'package:dar_care/core/utils/chat_presentation_utils.dart';
import 'package:dar_care/features/chat/presentation/models/chat_list_item.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChatListItemTile extends StatelessWidget {
  const ChatListItemTile({
    super.key,
    required this.chat,
    required this.onTap,
  });

  final ChatListItem chat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final providerName = chat.providerName.trim().isNotEmpty
        ? chat.providerName
        : LocaleKeys.chat_provider_fallback.tr();

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Theme.of(context).colorScheme.surface,
      leading: const CircleAvatar(child: Icon(Icons.person_outline)),
      title: Text(
        providerName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        formatChatStartedAt(chat.createdAt),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}

