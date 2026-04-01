import 'dart:async';

import 'package:dar_care/features/chat/data/models/chat_model.dart';
import 'package:dar_care/features/chat/data/models/message_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> getOrCreateChat({
    required String clientId,
    required String providerId,
  });

  Stream<List<MessageModel>> getMessagesStream(String chatId);

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  });
}

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient _supabase;

  ChatRemoteDataSourceImpl(this._supabase);

  @override
  Future<ChatModel> getOrCreateChat({
    required String clientId,
    required String providerId,
  }) async {
    final currentUserId = _requireCurrentUserId();

    final resolvedClientId =
        await _resolveClientProfileIdForCurrentUserOrFallback(
          currentUserId: currentUserId,
          fallbackInputId: clientId,
        );
    final resolvedProviderId = await _resolveProfileId(
      table: 'providers',
      inputId: providerId,
    );

    final existingChat = await _supabase
        .from('chats')
        .select()
        .eq('client_id', resolvedClientId)
        .eq('provider_id', resolvedProviderId)
        .maybeSingle();

    if (existingChat != null) {
      return ChatModel.fromJson(Map<String, dynamic>.from(existingChat));
    }

    final createdChat = await _supabase
        .from('chats')
        .insert({
          'client_id': resolvedClientId,
          'provider_id': resolvedProviderId,
        })
        .select()
        .single();

    return ChatModel.fromJson(Map<String, dynamic>.from(createdChat));
  }

  String _requireCurrentUserId() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('You must be signed in to use chat.');
    }
    return userId;
  }

  Future<String> _resolveClientProfileIdForCurrentUserOrFallback({
    required String currentUserId,
    required String fallbackInputId,
  }) async {
    final byCurrentUser = await _supabase
        .from('clients')
        .select('id')
        .eq('user_id', currentUserId)
        .maybeSingle();

    if (byCurrentUser != null && byCurrentUser['id'] != null) {
      return byCurrentUser['id'].toString();
    }

    return _resolveProfileId(table: 'clients', inputId: fallbackInputId);
  }

  Future<String> _resolveProfileId({
    required String table,
    required String inputId,
  }) async {
    final normalized = inputId.trim();
    if (normalized.isEmpty) {
      throw StateError('Missing $table identifier.');
    }

    final byId = await _supabase
        .from(table)
        .select('id')
        .eq('id', normalized)
        .maybeSingle();

    if (byId != null && byId['id'] != null) {
      return byId['id'].toString();
    }

    final byUserId = await _supabase
        .from(table)
        .select('id')
        .eq('user_id', normalized)
        .maybeSingle();

    if (byUserId != null && byUserId['id'] != null) {
      return byUserId['id'].toString();
    }

    throw StateError('No matching $table profile found for id: $inputId');
  }

  @override
  Stream<List<MessageModel>> getMessagesStream(String chatId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .order('created_at', ascending: true)
        .order('id', ascending: true)
        .map((rows) {
          final messages = rows
              .map((row) => MessageModel.fromJson(Map<String, dynamic>.from(row)))
              .toList(growable: true);

          messages.sort((a, b) {
            final byTime = a.createdAt.compareTo(b.createdAt);
            if (byTime != 0) {
              return byTime;
            }
            return a.id.compareTo(b.id);
          });

          return List<MessageModel>.unmodifiable(messages);
        });
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      return;
    }

    final senderUserId = _supabase.auth.currentUser?.id ?? senderId;

    await _supabase.from('messages').insert({
      'chat_id': chatId,
      'sender_id': senderUserId,
      'message': trimmedText,
      'is_read': false,
    });
  }
}
