import 'package:flutter/material.dart';

import '../constants/brand_config.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: BrandConfig.lightBg,
      colorScheme: const ColorScheme.light(
        primary: BrandConfig.accent,
        onPrimary: Colors.white,
        surface: BrandConfig.lightSurface,
        onSurface: BrandConfig.lightText,
        outline: BrandConfig.lightBorder,
      ),
      dividerColor: BrandConfig.lightBorder,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: BrandConfig.lightBg,
        foregroundColor: BrandConfig.lightText,
        centerTitle: true,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: BrandConfig.sidebarBg,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandConfig.lightSurface,
        hintStyle: const TextStyle(color: BrandConfig.lightTextMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BrandConfig.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: BrandConfig.sidebarText,
        textColor: BrandConfig.sidebarText,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: BrandConfig.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: BrandConfig.accent,
        onPrimary: Colors.white,
        surface: BrandConfig.darkSurface,
        onSurface: BrandConfig.darkText,
        outline: BrandConfig.darkBorder,
      ),
      dividerColor: BrandConfig.darkBorder,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: BrandConfig.darkBg,
        foregroundColor: BrandConfig.darkText,
        centerTitle: true,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: BrandConfig.sidebarBg,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandConfig.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BrandConfig.accent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color chatBackground(BuildContext context) =>
      isDark(context) ? BrandConfig.darkBg : BrandConfig.lightBg;

  static Color userBubble(BuildContext context) =>
      isDark(context) ? BrandConfig.userBubbleDark : BrandConfig.userBubbleLight;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? BrandConfig.darkText : BrandConfig.lightText;

  static Color textMuted(BuildContext context) =>
      isDark(context) ? BrandConfig.darkTextMuted : BrandConfig.lightTextMuted;

  static Color inputFill(BuildContext context) =>
      isDark(context) ? BrandConfig.darkSurface : BrandConfig.lightSurface;
}
