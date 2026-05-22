import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../core/theme/app_theme.dart';

class MarkdownMessage extends StatelessWidget {
  const MarkdownMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.textPrimary(context);
    final muted = AppTheme.textMuted(context);
    final codeBg = AppTheme.isDark(context)
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF0F0F0);

    if (isUser) {
      return SelectableText(text, style: TextStyle(color: color, height: 1.45, fontSize: 15));
    }

    return MarkdownBody(
      data: text,
      selectable: true,
      shrinkWrap: true,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(color: color, height: 1.5, fontSize: 15),
        h1: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
        h2: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        h3: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600),
        listBullet: TextStyle(color: color),
        code: TextStyle(color: color, backgroundColor: codeBg, fontFamily: 'monospace'),
        codeblockDecoration: BoxDecoration(color: codeBg, borderRadius: BorderRadius.circular(8)),
        blockquote: TextStyle(color: muted),
        strong: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
