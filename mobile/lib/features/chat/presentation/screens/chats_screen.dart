import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  late Future<List<_ChatListItem>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _chatsFuture = _loadChats();
  }

  Future<List<_ChatListItem>> _loadChats() async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      return const [];
    }

    final clientProfile = await _supabase
        .from('clients')
        .select('id')
        .eq('user_id', currentUserId)
        .maybeSingle();

    final clientId = clientProfile?['id']?.toString();
    if (clientId == null || clientId.isEmpty) {
      return const [];
    }

    final rows = await _supabase
        .from('chats')
        .select('id, provider_id, created_at, providers(id, user_id, users(full_name))')
        .eq('client_id', clientId)
        .order('created_at', ascending: false);

    return rows
        .map((row) => _ChatListItem.fromJson(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<void> _refreshChats() async {
    final future = _loadChats();
    setState(() {
      _chatsFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final userId = _supabase.auth.currentUser?.id;

    return Scaffold(
      appBar: const CustomAppBar(titleWidget: Text('Chats')),
      body: FutureBuilder<List<_ChatListItem>>(
        future: _chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Failed to load chats.'),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _refreshChats,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final chats = snapshot.data ?? const <_ChatListItem>[];
          if (chats.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshChats,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text('No chats yet.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshChats,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: chats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Theme.of(context).colorScheme.surface,
                  leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                  title: Text(
                    chat.providerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _formatCreatedAt(chat.createdAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: userId == null
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                currentUserId: userId,
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
        },
      ),
    );
  }

  String _formatCreatedAt(DateTime? value) {
    if (value == null) {
      return 'Started chat';
    }

    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return 'Started on $month/$day at $hour:$minute';
  }
}

class _ChatListItem {
  final String id;
  final String providerId;
  final String? providerUserId;
  final String providerName;
  final DateTime? createdAt;

  const _ChatListItem({
    required this.id,
    required this.providerId,
    required this.providerUserId,
    required this.providerName,
    required this.createdAt,
  });

  factory _ChatListItem.fromJson(Map<String, dynamic> json) {
    final provider = _asMap(json['providers']);
    final users = _asMap(provider['users']);

    return _ChatListItem(
      id: (json['id'] ?? '').toString(),
      providerId: (json['provider_id'] ?? '').toString(),
      providerUserId: provider['user_id']?.toString(),
      providerName: (users['full_name'] ?? 'Provider').toString(),
      createdAt: _parseDate(json['created_at']),
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is Map) {
        return Map<String, dynamic>.from(first);
      }
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}

