import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../services/api_client.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider({ChatService? chatService}) : _chat = chatService ?? ChatService();

  final ChatService _chat;

  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  int? _activeChatId;
  String? _activeChatTitle;
  bool _loading = false;
  bool _sending = false;
  String? _error;

  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  int? get activeChatId => _activeChatId;
  String get activeChatTitle {
    if (_activeChatId == null) return 'New conversation';
    if (_activeChatTitle != null && _activeChatTitle!.isNotEmpty) {
      return _activeChatTitle!;
    }
    final match = _chats.where((c) => c.id == _activeChatId);
    if (match.isNotEmpty) return match.first.title;
    return 'Conversation';
  }

  bool get isLoading => _loading;
  bool get isSending => _sending;
  String? get error => _error;

  Future<void> loadHistory() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _chats = await _chat.fetchHistory();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Something went wrong';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> openChat(int chatId) async {
    _activeChatId = chatId;
    try {
      _activeChatTitle = _chats.firstWhere((c) => c.id == chatId).title;
    } catch (_) {
      _activeChatTitle = null;
    }
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _messages = await _chat.fetchChatMessages(chatId);
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void startNewChat() {
    _activeChatId = null;
    _activeChatTitle = null;
    _messages = [];
    notifyListeners();
  }

  Future<bool> sendMessage(String text, {File? image}) async {
    if (text.trim().isEmpty && image == null) return false;
    _sending = true;
    _error = null;
    notifyListeners();

    final pending = MessageModel(
      id: -DateTime.now().millisecondsSinceEpoch,
      senderType: 'user',
      message: text,
      createdAt: DateTime.now(),
    );
    _messages = [..._messages, pending];
    notifyListeners();

    try {
      final result = await _chat.sendMessage(
        chatId: _activeChatId,
        message: text.trim().isEmpty ? 'Describe this image.' : text.trim(),
        image: image,
      );
      _activeChatId = result.chat.id;
      _activeChatTitle = result.chat.title;
      _messages = [
        ..._messages.where((m) => m.id != pending.id),
        ...result.messages,
      ];
      await loadHistory();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _messages = _messages.where((m) => m.id != pending.id).toList();
      return false;
    } catch (_) {
      _error = 'Something went wrong';
      _messages = _messages.where((m) => m.id != pending.id).toList();
      return false;
    } finally {
      _sending = false;
      notifyListeners();
    }
  }

  Future<bool> deleteChat(int chatId) async {
    try {
      await _chat.deleteChat(chatId);
      _chats = _chats.where((c) => c.id != chatId).toList();
      if (_activeChatId == chatId) {
        startNewChat();
      }
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<void> clearAll() async {
    try {
      await _chat.clearHistory();
      _chats = [];
      startNewChat();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
