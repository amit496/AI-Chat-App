import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/chat_input_bar.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _deleteCurrentChat(BuildContext context, ChatProvider chat) async {
    final id = chat.activeChatId;
    if (id == null) {
      Navigator.pop(context);
      return;
    }
    final title = chat.activeChatTitle;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete chat?'),
        content: Text('Remove "$title"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await chat.deleteChat(id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    if (chat.messages.isNotEmpty) _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          chat.activeChatTitle,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'settings':
                  Navigator.pushNamed(context, AppRoutes.settings);
                case 'delete':
                  await _deleteCurrentChat(context, chat);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (chat.activeChatId != null)
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.redAccent),
                    title: Text('Delete chat'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (chat.error != null)
            MaterialBanner(
              content: Text(chat.error!),
              actions: [
                TextButton(onPressed: chat.clearError, child: const Text('Dismiss')),
              ],
            ),
          Expanded(
            child: chat.isLoading && chat.messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: chat.messages.length + (chat.isSending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (chat.isSending && index == chat.messages.length) {
                        return const TypingIndicator();
                      }
                      return MessageBubble(message: chat.messages[index]);
                    },
                  ),
          ),
          ChatInputBar(
            enabled: !chat.isSending,
            onSend: (text, image) async {
              await chat.sendMessage(text, image: image);
            },
          ),
        ],
      ),
    );
  }
}
