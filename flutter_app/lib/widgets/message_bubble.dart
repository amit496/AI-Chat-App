import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

import '../core/constants/brand_config.dart';
import '../models/message_model.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({super.key, required this.message});

  final MessageModel message;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final FlutterTts _tts = FlutterTts();
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
    for (var i = 0; i <= text.length; i++) {
      if (!mounted) return;
      await Future<void>.delayed(const Duration(milliseconds: 8));
      setState(() {
        _displayText = text.substring(0, i);
        _typingDone = i == text.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;
    final time = widget.message.createdAt != null
        ? DateFormat('HH:mm').format(widget.message.createdAt!.toLocal())
        : '';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () async {
          await Clipboard.setData(ClipboardData(text: widget.message.message));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Message copied')),
            );
          }
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
          margin: EdgeInsets.only(
            left: isUser ? 48 : 12,
            right: isUser ? 12 : 48,
            top: 6,
            bottom: 6,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser
                ? BrandConfig.primary
                : BrandConfig.primaryLight,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isUser ? 18 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 18),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.message.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.message.imageUrl!,
                    height: 160,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const SizedBox(
                      height: 160,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  ),
                ),
              if (widget.message.imageUrl != null) const SizedBox(height: 8),
              Text(
                _displayText,
                style: TextStyle(
                  color: isUser ? Colors.white : BrandConfig.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isUser
                              ? Colors.white.withValues(alpha: 0.75)
                              : BrandConfig.textSecondary,
                        ),
                  ),
                  if (!isUser && _typingDone) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _tts.speak(widget.message.message),
                      child: Icon(
                        Icons.volume_up_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
