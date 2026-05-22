import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _toggleVoice() async {
    if (!_listening) {
      final available = await _speech.initialize();
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Voice input not available on this device')),
          );
        }
        return;
      }
      setState(() => _listening = true);
      await _speech.listen(
        onResult: (result) {
          _controller.text = result.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        },
      );
    } else {
      await _speech.stop();
      setState(() => _listening = false);
    }
  }

  void _submit() {
    if (!widget.enabled) return;
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_image != null)
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_image!, width: 56, height: 56, fit: BoxFit.cover),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _image = null),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            Row(
              children: [
                IconButton(
                  onPressed: widget.enabled ? _pickImage : null,
                  icon: const Icon(Icons.image_outlined),
                ),
                IconButton(
                  onPressed: widget.enabled ? _toggleVoice : null,
                  icon: Icon(_listening ? Icons.mic : Icons.mic_none),
                  color: _listening ? Theme.of(context).colorScheme.primary : null,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: widget.enabled,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Ask NovaAI anything...',
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: widget.enabled ? _submit : null,
                  style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(14)),
                  child: const Icon(Icons.send_rounded, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
