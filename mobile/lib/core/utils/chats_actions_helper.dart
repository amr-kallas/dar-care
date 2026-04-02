import 'package:dar_care/features/chat/presentation/models/chat_list_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatsActionsHelper {
  const ChatsActionsHelper();

  String? currentUserId(SupabaseClient supabase) {
    return supabase.auth.currentUser?.id;
  }

  Future<List<ChatListItem>> loadChats(SupabaseClient supabase) async {
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
        .select('id, provider_id, created_at, providers(id, user_id, users(full_name))')
        .eq('client_id', clientId)
        .order('created_at', ascending: false);

    return rows
        .map((row) => ChatListItem.fromJson(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }
}

