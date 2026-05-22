import 'package:flutter/material.dart' show Color;

/// Zynthio — ChatGPT-style layout & colors
class BrandConfig {
  BrandConfig._();

  static const String appName = 'Zynthio';
  static const String tagline = 'How can I help you today?';
  static const String chatHint = 'Message Zynthio';
  static const String logoAsset = 'assets/logo/logo.png';

  // ChatGPT accent (send, links)
  static const Color accent = Color(0xFF10A37F);
  static const Color accentDark = Color(0xFF0D8F6E);

  // Light mode
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F7F8);
  static const Color lightBorder = Color(0xFFE5E5E5);
  static const Color lightText = Color(0xFF0D0D0D);
  static const Color lightTextMuted = Color(0xFF6E6E80);
  static const Color userBubbleLight = Color(0xFFF4F4F4);

  // Dark mode
  static const Color darkBg = Color(0xFF212121);
  static const Color darkSurface = Color(0xFF2F2F2F);
  static const Color darkBorder = Color(0xFF3F3F3F);
  static const Color darkText = Color(0xFFECECEC);
  static const Color darkTextMuted = Color(0xFFB4B4B4);
  static const Color userBubbleDark = Color(0xFF2F2F2F);

  // Sidebar (ChatGPT dark drawer)
  static const Color sidebarBg = Color(0xFF171717);
  static const Color sidebarHover = Color(0xFF2A2A2A);
  static const Color sidebarText = Color(0xFFECECEC);
  static const Color sidebarMuted = Color(0xFF8E8E8E);

  // Legacy aliases
  static const Color primary = accent;
  static const Color primaryDark = accentDark;
  static const Color primaryLight = lightSurface;
  static const Color surface = lightBg;
  static const Color surfaceCard = lightSurface;
  static const Color textPrimary = lightText;
  static const Color textSecondary = lightTextMuted;
  static const Color border = lightBorder;
}
