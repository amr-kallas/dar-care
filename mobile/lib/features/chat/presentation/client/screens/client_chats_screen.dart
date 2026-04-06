import 'package:dar_care/core/utils/chat_presentation_utils.dart';
import 'package:dar_care/core/utils/chats_actions_helper.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_overview_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientChatsScreen extends StatelessWidget {
  const ClientChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    const actionsHelper = ChatsActionsHelper();
    final userId = actionsHelper.currentUserId(supabase);

    return ChatsOverviewScaffold(
      currentUserId: userId,
      loadChats: () => actionsHelper.loadClientChats(supabase),
      resolveDisplayName: (chat) => resolveProviderName(chat.providerName),
      onOpenChat: (context, chat) => actionsHelper.openClientChat(
        context: context,
        currentUserId: userId!,
        providerId: chat.providerId,
        title: resolveProviderName(chat.providerName),
        markAsStale: false,
      ),
    );
  }
}
