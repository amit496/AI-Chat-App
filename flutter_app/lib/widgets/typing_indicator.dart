import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'brand_logo.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

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
          FadeTransition(
            opacity: Tween(begin: 0.4, end: 1.0).animate(
              CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
            ),
            child: Text(
              'Zynthio is thinking…',
              style: TextStyle(color: AppTheme.textMuted(context), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
