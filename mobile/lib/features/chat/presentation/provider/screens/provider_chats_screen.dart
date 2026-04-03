import 'package:dar_care/core/utils/chats_actions_helper.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/chat/data/models/chat_list_item.dart';
import 'package:dar_care/features/chat/presentation/provider/screens/provider_chat_screen.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_empty_state.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_error_state.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderChatsScreen extends StatefulWidget {
  const ProviderChatsScreen({super.key});

  @override
  State<ProviderChatsScreen> createState() => _ProviderChatsScreenState();
}

class _ProviderChatsScreenState extends State<ProviderChatsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ChatsActionsHelper _actionsHelper = const ChatsActionsHelper();

  late Future<List<ChatListItem>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _chatsFuture = _actionsHelper.loadProviderChatsFromActiveOrders(_supabase);
  }

  Future<void> _refreshChats() async {
    final future = _actionsHelper.loadProviderChatsFromActiveOrders(_supabase);
    setState(() {
      _chatsFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _actionsHelper.currentUserId(_supabase);

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

          return RefreshIndicator(
            onRefresh: _refreshChats,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: chats.length,
              separatorBuilder: (_, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final chat = chats[index];
                final clientName = chat.clientName?.trim().isNotEmpty == true
                    ? chat.clientName!.trim()
                    : LocaleKeys.home_unknown_user.tr();
                final hasValidRouteIds =
                    chat.providerId.trim().isNotEmpty &&
                    chat.clientId != null &&
                    chat.clientId!.isNotEmpty;

                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Theme.of(context).colorScheme.surface,
                  leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                  title: Text(
                    clientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    chat.createdAt == null
                        ? LocaleKeys.chat_started.tr()
                        : DateFormat('d MMM y - hh:mm a', context.locale.languageCode)
                              .format(chat.createdAt!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: currentUserId == null ||
                          currentUserId.isEmpty ||
                          !hasValidRouteIds
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProviderChatScreen(
                                currentUserId: currentUserId,
                                providerId: chat.providerId,
                                clientId: chat.clientId!,
                                title: clientName,
                              ),
                            ),
                          );
                        },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
