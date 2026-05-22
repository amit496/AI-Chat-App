import 'dart:io';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../core/constants/brand_config.dart';
import '../core/theme/app_theme.dart';
import 'image_attach_sheet.dart';

/// ChatGPT-style bottom composer: one rounded bar + attach + send.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    this.enabled = true,
  });

  final void Function(String text, File? image) onSend;
  final bool enabled;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  File? _image;
  bool _listening = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _attachImage() async {
    final file = await showImageAttachSheet(context);
    if (file != null) setState(() => _image = file);
  }

  Future<void> _toggleVoice() async {
    if (!_listening) {
      final ok = await _speech.initialize();
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Voice not available')),
        );
        return;
      }
      setState(() => _listening = true);
      await _speech.listen(
        onResult: (r) {
          _controller.text = r.recognizedWords;
        },
      );
    } else {
      await _speech.stop();
      setState(() => _listening = false);
    }
  }

  void _submit() {
    if (!widget.enabled) return;
    if (_controller.text.trim().isEmpty && _image == null) return;
    widget.onSend(_controller.text, _image);
    _controller.clear();
    setState(() => _image = null);
    if (_listening) {
      _speech.stop();
      _listening = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fill = AppTheme.inputFill(context);
    final border = AppTheme.isDark(context) ? BrandConfig.darkBorder : BrandConfig.lightBorder;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_image != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_image!, width: 48, height: 48, fit: BoxFit.cover),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => setState(() => _image = null),
                    ),
                  ],
                ),
              ),
            Container(
              constraints: const BoxConstraints(maxWidth: 768),
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, size: 22),
                    color: AppTheme.textMuted(context),
                    onPressed: widget.enabled ? _attachImage : null,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: widget.enabled,
                      minLines: 1,
                      maxLines: 8,
                      style: TextStyle(color: AppTheme.textPrimary(context), fontSize: 15),
                      decoration: InputDecoration(
                        hintText: BrandConfig.chatHint,
                        hintStyle: TextStyle(color: AppTheme.textMuted(context)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_listening ? Icons.mic : Icons.mic_none, size: 22),
                    color: _listening ? BrandConfig.accent : AppTheme.textMuted(context),
                    onPressed: widget.enabled ? _toggleVoice : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6, bottom: 6),
                    child: Material(
                      color: widget.enabled ? BrandConfig.accent : BrandConfig.lightBorder,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: widget.enabled ? _submit : null,
                        child: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(Icons.arrow_upward, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Zynthio can make mistakes. Check important info.',
              style: TextStyle(fontSize: 11, color: AppTheme.textMuted(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
