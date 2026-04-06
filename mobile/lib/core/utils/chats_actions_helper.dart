import 'package:dar_care/core/utils/app_refresh_notifier.dart';
import 'package:dar_care/features/chat/data/models/chat_list_item.dart';
import 'package:dar_care/features/chat/presentation/client/screens/client_chat_screen.dart';
import 'package:dar_care/features/chat/presentation/provider/screens/provider_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatsActionsHelper {
  const ChatsActionsHelper();

  String? currentUserId(SupabaseClient supabase) {
    return supabase.auth.currentUser?.id;
  }

  Future<void> openClientChat({
    required BuildContext context,
    required String currentUserId,
    required String providerId,
    String? title,
    String? explicitClientId,
    bool markAsStale = true,
  }) async {
    if (markAsStale) {
      appRefreshNotifier.markChatsStale();
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientChatScreen(
          currentUserId: currentUserId,
          providerId: providerId,
          explicitClientId: explicitClientId,
          title: title,
        ),
      ),
    );
  }

  Future<void> openProviderChat({
    required BuildContext context,
    required String currentUserId,
    required String providerId,
    required String clientId,
    String? title,
    bool markAsStale = true,
  }) async {
    if (markAsStale) {
      appRefreshNotifier.markChatsStale();
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProviderChatScreen(
          currentUserId: currentUserId,
          providerId: providerId,
          clientId: clientId,
          title: title,
        ),
      ),
    );
  }

  Future<List<ChatListItem>> loadChats(SupabaseClient supabase) {
    return loadClientChats(supabase);
  }

  Future<List<ChatListItem>> loadClientChats(SupabaseClient supabase) async {
    final userId = currentUserId(supabase);
    if (userId == null) {
      return const [];
    }

    final clientProfile = await supabase
        .from('clients')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    final clientId = clientProfile?['id']?.toString();
    if (clientId == null || clientId.isEmpty) {
      return const [];
    }

    final rows = await supabase
        .from('chats')
        .select('id, client_id, provider_id, created_at, providers(id, user_id, users(full_name))')
        .eq('client_id', clientId)
        .order('created_at', ascending: false);

    return rows
        .map((row) => ChatListItem.fromJson(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<List<ChatListItem>> loadProviderChatsFromActiveOrders(
    SupabaseClient supabase,
  ) async {
    final userId = currentUserId(supabase);
    if (userId == null) {
      return const [];
    }

    final providerProfile = await supabase
        .from('providers')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    final providerId = providerProfile?['id']?.toString();
    if (providerId == null || providerId.isEmpty) {
      return const [];
    }

    final rows = await supabase
        .from('orders')
        .select('id, provider_id, client_id, status, created_at, clients(id, user_id, users(id, full_name))')
        .eq('provider_id', providerId)
        .inFilter('status', ['accepted', 'in_progress'])
        .order('created_at', ascending: false);

    final items = rows
        .map((row) => ChatListItem.fromProviderOrderRow(Map<String, dynamic>.from(row)))
        .where((item) => item.clientId != null && item.clientId!.isNotEmpty)
        .toList(growable: false);

    final seenClientIds = <String>{};
    final deduped = <ChatListItem>[];
    for (final item in items) {
      final clientId = item.clientId!;
      if (seenClientIds.add(clientId)) {
        deduped.add(item);
      }
    }

    return deduped;
  }
}
