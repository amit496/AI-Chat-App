import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/constants/brand_config.dart';
import '../core/theme/app_theme.dart';
import 'brand_logo.dart';

enum LogoSize { small, medium, large, hero }

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = LogoSize.medium,
    this.showName = true,
    this.inSidebar = false,
  });

  final LogoSize size;
  final bool showName;
  final bool inSidebar;

  double get _imageSize => switch (size) {
        LogoSize.small => 32,
        LogoSize.medium => 48,
        LogoSize.large => 72,
        LogoSize.hero => 120,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandLogo(
          size: _imageSize,
          variant: inSidebar
              ? LogoVariant.sidebar
              : BrandLogo.variantFor(context),
        ),
        if (showName) ...[
          SizedBox(height: size == LogoSize.hero ? 16 : 8),
          Text(
            AppStrings.appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: inSidebar
                      ? BrandConfig.sidebarText
                      : AppTheme.textPrimary(context),
                ),
          ),
        ],
      ],
    );
  }
}
