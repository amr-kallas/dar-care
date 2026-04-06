import 'package:dar_care/core/utils/chat_presentation_utils.dart';
import 'package:dar_care/core/utils/chats_actions_helper.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_overview_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderChatsScreen extends StatelessWidget {
  const ProviderChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    const actionsHelper = ChatsActionsHelper();
    final currentUserId = actionsHelper.currentUserId(supabase);

    return ChatsOverviewScaffold(
      currentUserId: currentUserId,
      loadChats: () => actionsHelper.loadProviderChatsFromActiveOrders(supabase),
      resolveDisplayName: (chat) => resolveClientName(chat.clientName),
      canOpenChat: (chat) =>
          chat.providerId.trim().isNotEmpty &&
          (chat.clientId?.trim().isNotEmpty ?? false),
      onOpenChat: (context, chat) => actionsHelper.openProviderChat(
        context: context,
        currentUserId: currentUserId!,
        providerId: chat.providerId,
        clientId: chat.clientId!,
        title: resolveClientName(chat.clientName),
        markAsStale: false,
      ),
    );
  }
}
