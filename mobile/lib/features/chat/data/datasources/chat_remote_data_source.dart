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

    final resolvedClientId = await _resolveClientProfileIdForCurrentUserOrFallback(
      currentUserId: currentUserId,
      fallbackInputId: clientId,
    );
    final resolvedProviderId = await _resolveProviderProfileId(
      currentUserId: currentUserId,
      inputId: providerId,
    );

    final existingRows = await _supabase
        .from('chats')
        .select()
        .eq('client_id', resolvedClientId)
        .eq('provider_id', resolvedProviderId)
        .order('created_at', ascending: false)
        .limit(1);

    if (existingRows.isNotEmpty) {
      return ChatModel.fromJson(Map<String, dynamic>.from(existingRows.first));
    }

    try {
      final createdChat = await _supabase
          .from('chats')
          .insert({
            'client_id': resolvedClientId,
            'provider_id': resolvedProviderId,
          })
          .select()
          .single();

      return ChatModel.fromJson(Map<String, dynamic>.from(createdChat));
    } on PostgrestException {
      // If another request creates the chat concurrently, return the latest one.
      final fallbackRows = await _supabase
          .from('chats')
          .select()
          .eq('client_id', resolvedClientId)
          .eq('provider_id', resolvedProviderId)
          .order('created_at', ascending: false)
          .limit(1);

      if (fallbackRows.isNotEmpty) {
        return ChatModel.fromJson(Map<String, dynamic>.from(fallbackRows.first));
      }

      rethrow;
    }
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

    final normalizedFallbackId = fallbackInputId.trim();
    if (normalizedFallbackId.isEmpty) {
      throw StateError('Missing clients identifier.');
    }

    final clientIdByFallback = await _resolveClientProfileIdFromAnyIdentifier(
      normalizedFallbackId,
    );
    if (clientIdByFallback != null) {
      return clientIdByFallback;
    }

    // When a provider opens chat from an order we may already receive a client profile id,
    // and RLS can block probing another user's profile rows.
    if (normalizedFallbackId != currentUserId) {
      return normalizedFallbackId;
    }

    throw StateError('No matching clients profile found for id: $fallbackInputId');
  }

  Future<String> _resolveProviderProfileId({
    required String currentUserId,
    required String inputId,
  }) async {
    // Prefer the signed-in user's provider profile when available.
    final byCurrentUser = await _supabase
        .from('providers')
        .select('id')
        .eq('user_id', currentUserId)
        .maybeSingle();

    if (byCurrentUser != null && byCurrentUser['id'] != null) {
      return byCurrentUser['id'].toString();
    }

    final normalized = inputId.trim();
    if (normalized.isEmpty) {
      throw StateError('Missing providers identifier.');
    }

    // For client-side chat openings, normalize provider profile id from either profile id or auth user id.
    final providerIdByInput = await _resolveProviderProfileIdFromAnyIdentifier(
      normalized,
    );
    if (providerIdByInput != null) {
      return providerIdByInput;
    }

    // Keep compatibility when RLS blocks provider probes and caller already has provider profile id.
    return normalized;
  }

  Future<String?> _resolveClientProfileIdFromAnyIdentifier(String inputId) async {
    try {
      final rows = await _supabase
          .from('clients')
          .select('id')
          .or('id.eq.$inputId,user_id.eq.$inputId')
          .limit(1);

      if (rows.isNotEmpty) {
        final id = rows.first['id']?.toString();
        if (id != null && id.isNotEmpty) {
          return id;
        }
      }
    } on PostgrestException {
      // Keep fallback behavior for projects where providers cannot read clients directly.
    }

    return null;
  }

  Future<String?> _resolveProviderProfileIdFromAnyIdentifier(String inputId) async {
    try {
      final rows = await _supabase
          .from('providers')
          .select('id')
          .or('id.eq.$inputId,user_id.eq.$inputId')
          .limit(1);

      if (rows.isNotEmpty) {
        final id = rows.first['id']?.toString();
        if (id != null && id.isNotEmpty) {
          return id;
        }
      }
    } on PostgrestException {
      // Keep fallback behavior for projects where clients cannot read providers directly.
    }

    return null;
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

    final senderUserId = _requireCurrentUserId();

    await _supabase.from('messages').insert({
      'chat_id': chatId,
      'sender_id': senderUserId,
      'message': trimmedText,
      'is_read': false,
    });
  }
}
