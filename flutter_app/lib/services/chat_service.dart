import 'dart:io';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'api_client.dart';

class ChatService {
  ChatService({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;

  Future<({ChatModel chat, List<MessageModel> messages})> sendMessage({
    int? chatId,
    required String message,
    File? image,
  }) async {
    final fields = <String, String>{
      'message': message,
      if (chatId != null) 'chat_id': chatId.toString(),
    };

    final data = image != null
        ? await _api.postMultipart('/send-message', fields: fields, file: image)
        : await _api.post('/send-message', body: {
            'message': message,
            if (chatId != null) 'chat_id': chatId,
          });

    final chatJson = data['chat'] as Map<String, dynamic>;
    final messages = (data['messages'] as List<dynamic>)
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return (
      chat: ChatModel.fromJson(chatJson),
      messages: messages,
    );
  }

  Future<List<ChatModel>> fetchHistory() async {
    final data = await _api.get('/chat-history');
    return (data['chats'] as List<dynamic>)
        .map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MessageModel>> fetchChatMessages(int chatId) async {
    final data = await _api.get('/chats/$chatId');
    return (data['messages'] as List<dynamic>)
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteChat(int chatId) async {
    await _api.delete('/delete-chat/$chatId');
  }

  Future<void> clearHistory() async {
    await _api.delete('/clear-chat-history');
  }
}
