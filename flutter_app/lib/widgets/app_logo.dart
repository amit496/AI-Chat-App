import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';

enum LogoSize { small, medium, large, hero }

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = LogoSize.medium,
    this.showName = true,
  });

  final LogoSize size;
  final bool showName;

  double get _imageSize => switch (size) {
        LogoSize.small => 32,
        LogoSize.medium => 48,
        LogoSize.large => 72,
        LogoSize.hero => 120,
      };

  TextStyle? _titleStyle(BuildContext context) => switch (size) {
        LogoSize.small => Theme.of(context).textTheme.titleMedium,
        LogoSize.medium => Theme.of(context).textTheme.titleLarge,
        LogoSize.large => Theme.of(context).textTheme.headlineSmall,
        LogoSize.hero => Theme.of(context).textTheme.headlineMedium,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(_imageSize * 0.22),
          child: Image.asset(
            'assets/logo/logo.png',
            width: _imageSize,
            height: _imageSize,
            fit: BoxFit.cover,
          ),
        ),
        if (showName) ...[
          SizedBox(height: size == LogoSize.hero ? 16 : 8),
          Text(
            AppStrings.appName,
            style: _titleStyle(context)?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }
}
