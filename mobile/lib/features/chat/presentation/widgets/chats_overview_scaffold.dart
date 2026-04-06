import 'package:dar_care/core/utils/app_refresh_notifier.dart';
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/features/chat/data/models/chat_list_item.dart';
import 'package:dar_care/features/chat/presentation/widgets/chats_overview_body.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChatsOverviewScaffold extends StatefulWidget {
  const ChatsOverviewScaffold({
    super.key,
    required this.currentUserId,
    required this.loadChats,
    required this.resolveDisplayName,
    required this.onOpenChat,
    this.canOpenChat,
  });

  final String? currentUserId;
  final Future<List<ChatListItem>> Function() loadChats;
  final String Function(ChatListItem chat) resolveDisplayName;
  final Future<void> Function(BuildContext context, ChatListItem chat) onOpenChat;
  final bool Function(ChatListItem chat)? canOpenChat;

  @override
  State<ChatsOverviewScaffold> createState() => _ChatsOverviewScaffoldState();
}

class _ChatsOverviewScaffoldState extends State<ChatsOverviewScaffold> {
  late Future<List<ChatListItem>> _chatsFuture;
  int _lastChatsVersion = 0;

  @override
  void initState() {
    super.initState();
    _lastChatsVersion = appRefreshNotifier.chatsVersion;
    appRefreshNotifier.addListener(_onGlobalRefresh);
    _chatsFuture = widget.loadChats();
  }

  @override
  void dispose() {
    appRefreshNotifier.removeListener(_onGlobalRefresh);
    super.dispose();
  }

  void _onGlobalRefresh() {
    if (!mounted) {
      return;
    }

    if (_lastChatsVersion == appRefreshNotifier.chatsVersion) {
      return;
    }

    _lastChatsVersion = appRefreshNotifier.chatsVersion;
    _refreshChats();
  }

  Future<void> _refreshChats() async {
    final future = widget.loadChats();
    setState(() {
      _chatsFuture = future;
    });
    await future;
  }

  bool _canTap(ChatListItem chat) {
    final currentUserId = widget.currentUserId;
    if (currentUserId == null || currentUserId.isEmpty) {
      return false;
    }

    final customGuard = widget.canOpenChat;
    if (customGuard == null) {
      return true;
    }

    return customGuard(chat);
  }

  VoidCallback? _buildOnTap(BuildContext context, ChatListItem chat) {
    if (!_canTap(chat)) {
      return null;
    }

    return () async {
      await widget.onOpenChat(context, chat);
      if (mounted) {
        await _refreshChats();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleWidget: Text(LocaleKeys.chats_title.tr())),
      body: ChatsOverviewBody(
        chatsFuture: _chatsFuture,
        onRefresh: _refreshChats,
        resolveDisplayName: widget.resolveDisplayName,
        onTapBuilder: (chat) => _buildOnTap(context, chat),
      ),
    );
  }
}

