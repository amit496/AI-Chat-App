import 'package:flutter/material.dart' show Color;

/// Zynthio — soft, eye-friendly palette
class BrandConfig {
  BrandConfig._();

  static const String appName = 'Zynthio';
  static const String tagline = 'Smart. Clear. Chat.';
  static const String chatHint = 'Ask Zynthio anything...';
  static const String logoAsset = 'assets/logo/logo.png';

  // Soft dusty blue-lavender (low saturation)
  static const Color primary = Color(0xFF7C8DB5);
  static const Color primaryDark = Color(0xFF6B7CA3);
  static const Color primaryLight = Color(0xFFE8ECF4);

  static const Color surface = Color(0xFFF5F6FA);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE2E6EF);
}
