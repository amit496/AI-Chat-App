import 'package:flutter/material.dart';

import '../core/constants/brand_config.dart';
import '../core/theme/app_theme.dart';

/// Themed logo — colors follow light / dark / sidebar / accent.
enum LogoVariant { light, dark, sidebar, accent }

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    required this.size,
    this.variant,
    this.borderRadius,
  });

  final double size;
  final LogoVariant? variant;
  final double? borderRadius;

  static LogoVariant variantFor(BuildContext context, {bool inSidebar = false}) {
    if (inSidebar) return LogoVariant.sidebar;
    return AppTheme.isDark(context) ? LogoVariant.dark : LogoVariant.light;
  }

  List<Color> _gradient(LogoVariant v) {
    switch (v) {
      case LogoVariant.sidebar:
        return const [Color(0xFF2A2A2A), Color(0xFF353535)];
      case LogoVariant.dark:
        return [BrandConfig.darkSurface, const Color(0xFF3A3A3A)];
      case LogoVariant.accent:
        return [BrandConfig.accent, BrandConfig.accentDark];
      case LogoVariant.light:
        return [BrandConfig.accent.withValues(alpha: 0.12), BrandConfig.accent.withValues(alpha: 0.22)];
    }
  }

  Color _border(LogoVariant v) {
    switch (v) {
      case LogoVariant.sidebar:
        return const Color(0xFF3F3F3F);
      case LogoVariant.accent:
        return BrandConfig.accent.withValues(alpha: 0.35);
      case LogoVariant.dark:
        return BrandConfig.darkBorder;
      case LogoVariant.light:
        return BrandConfig.accent.withValues(alpha: 0.3);
    }
  }

  Color _iconColor(LogoVariant v) {
    switch (v) {
      case LogoVariant.sidebar:
      case LogoVariant.dark:
        return BrandConfig.accent;
      case LogoVariant.accent:
        return Colors.white;
      case LogoVariant.light:
        return BrandConfig.accentDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = variant ?? variantFor(context);
    final radius = borderRadius ?? size * 0.22;
    final iconSize = size * 0.52;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradient(v),
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: _border(v), width: 1),
        boxShadow: v == LogoVariant.sidebar
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: AppTheme.isDark(context) ? 0.25 : 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Icon(
        Icons.auto_awesome,
        size: iconSize,
        color: _iconColor(v),
      ),
    );
  }
}
