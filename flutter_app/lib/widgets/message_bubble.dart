import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../models/message_model.dart';
import 'brand_logo.dart';
import 'markdown_message.dart';

/// ChatGPT-style messages: user bubble right, AI full-width with avatar.
class MessageBubble extends StatefulWidget {
  const MessageBubble({super.key, required this.message});

  final MessageModel message;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _typingDone = false;
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    if (widget.message.isUser) {
      _displayText = widget.message.message;
      _typingDone = true;
    } else {
      _animateTyping();
    }
  }

  Future<void> _animateTyping() async {
    final text = widget.message.message;
    if (text.length > 500) {
      setState(() {
        _displayText = text;
        _typingDone = true;
      });
      return;
    }
    for (var i = 0; i <= text.length; i++) {
      if (!mounted) return;
      await Future<void>.delayed(const Duration(milliseconds: 4));
      setState(() {
        _displayText = text.substring(0, i);
        _typingDone = i == text.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;

    if (isUser) {
      return _UserMessage(text: widget.message.message, imageUrl: widget.message.imageUrl);
    }

    return _AiMessage(
      text: _displayText,
      imageUrl: widget.message.imageUrl,
      typingDone: _typingDone,
      fullText: widget.message.message,
    );
  }
}

class _UserMessage extends StatelessWidget {
  const _UserMessage({required this.text, this.imageUrl});

  final String text;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: GestureDetector(
              onLongPress: () => Clipboard.setData(ClipboardData(text: text)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.userBubble(context),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(imageUrl: imageUrl!, height: 140, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: AppTheme.textPrimary(context),
                        height: 1.45,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiMessage extends StatelessWidget {
  const _AiMessage({
    required this.text,
    required this.typingDone,
    required this.fullText,
    this.imageUrl,
  });

  final String text;
  final bool typingDone;
  final String fullText;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandLogo(
            size: 28,
            variant: BrandLogo.variantFor(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onLongPress: () => Clipboard.setData(ClipboardData(text: fullText)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(imageUrl: imageUrl!, height: 160, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (!typingDone)
                    Text(text, style: TextStyle(color: AppTheme.textPrimary(context), height: 1.5, fontSize: 15))
                  else
                    MarkdownMessage(text: text, isUser: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
