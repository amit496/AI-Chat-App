import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/brand_config.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/brand_logo.dart';
import '../../widgets/chat_input_bar.dart';
import '../../widgets/chatgpt_sidebar.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/typing_indicator.dart';

/// ChatGPT-style main screen: sidebar + chat + bottom input.
class ChatShellScreen extends StatefulWidget {
  const ChatShellScreen({super.key});

  @override
  State<ChatShellScreen> createState() => _ChatShellScreenState();
}

class _ChatShellScreenState extends State<ChatShellScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadHistory();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final isDark = AppTheme.isDark(context);

    if (chat.messages.isNotEmpty) _scrollToBottom();

    final hasMessages = chat.messages.isNotEmpty || chat.isSending;

    return Scaffold(
      backgroundColor: AppTheme.chatBackground(context),
      drawer: const ChatGptSidebar(),
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          chat.activeChatId == null ? BrandConfig.appName : chat.activeChatTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'New chat',
            icon: const Icon(Icons.edit_square, size: 22),
            onPressed: () => context.read<ChatProvider>().startNewChat(),
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
            child: chat.isLoading && !hasMessages
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : !hasMessages
                    ? _EmptyChatState(isDark: isDark, onSuggestion: (text) {
                        context.read<ChatProvider>().sendMessage(text);
                      })
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
            onSend: (text, image) => chat.sendMessage(text, image: image),
          ),
        ],
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState({required this.isDark, required this.onSuggestion});

  final bool isDark;
  final void Function(String text) onSuggestion;

  static const _suggestions = [
    'Explain quantum computing simply',
    'Write a professional email',
    'Help me debug my code',
    'Plan a weekend trip',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BrandLogo(
                size: 56,
                variant: BrandLogo.variantFor(context),
              ),
              const SizedBox(height: 20),
              Text(
                BrandConfig.tagline,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: _suggestions.map((s) {
                  return ActionChip(
                    label: Text(s, style: const TextStyle(fontSize: 13)),
                    backgroundColor: isDark ? BrandConfig.darkSurface : BrandConfig.lightSurface,
                    side: BorderSide(color: isDark ? BrandConfig.darkBorder : BrandConfig.lightBorder),
                    onPressed: () => onSuggestion(s),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
