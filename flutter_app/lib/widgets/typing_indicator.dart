import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import 'loading_dots.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.loading,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            const LoadingDots(),
          ],
        ),
      ),
    );
  }
}
