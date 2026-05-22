import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../widgets/app_logo.dart';
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
        title: Row(
          children: [
            const AppLogo(size: LogoSize.small, showName: false),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                chat.activeChatId == null ? 'New chat' : 'Chat #${chat.activeChatId}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
