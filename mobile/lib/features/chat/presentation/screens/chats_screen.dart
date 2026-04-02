import 'package:dar_care/core/utils/chats_actions_helper.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/chat/presentation/models/chat_list_item.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_empty_state.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_error_state.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_list_view.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ChatsActionsHelper _actionsHelper = const ChatsActionsHelper();

  late Future<List<ChatListItem>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _chatsFuture = _actionsHelper.loadChats(_supabase);
  }

  Future<void> _refreshChats() async {
    final future = _actionsHelper.loadChats(_supabase);
    setState(() {
      _chatsFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final userId = _actionsHelper.currentUserId(_supabase);

    return Scaffold(
      appBar: CustomAppBar(titleWidget: Text(LocaleKeys.chats_title.tr())),
      body: FutureBuilder<List<ChatListItem>>(
        future: _chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ChatsErrorState(onRetry: _refreshChats);
          }

          final chats = snapshot.data ?? const <ChatListItem>[];
          if (chats.isEmpty) {
            return ChatsEmptyState(onRefresh: _refreshChats);
          }

          return ChatsListView(
            chats: chats,
            currentUserId: userId,
            onRefresh: _refreshChats,
          );
        },
      ),
    );
  }
}
