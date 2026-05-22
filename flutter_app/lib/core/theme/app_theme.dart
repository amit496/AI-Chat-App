import 'package:flutter/material.dart';

import '../constants/brand_config.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: BrandConfig.surface,
      colorScheme: const ColorScheme.light(
        primary: BrandConfig.primary,
        onPrimary: Colors.white,
        secondary: BrandConfig.primaryLight,
        onSecondary: BrandConfig.textPrimary,
        surface: BrandConfig.surfaceCard,
        onSurface: BrandConfig.textPrimary,
        outline: BrandConfig.border,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: BrandConfig.textPrimary),
        bodyMedium: TextStyle(color: BrandConfig.textSecondary),
        headlineMedium: TextStyle(
          color: BrandConfig.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: BrandConfig.surface,
        foregroundColor: BrandConfig.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BrandConfig.surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BrandConfig.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BrandConfig.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BrandConfig.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BrandConfig.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrandConfig.textPrimary,
          side: const BorderSide(color: BrandConfig.border),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: BrandConfig.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: BrandConfig.border),
        ),
      ),
      dividerColor: BrandConfig.border,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1C1F26),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9AA8C7),
        onPrimary: Color(0xFF1C1F26),
        surface: Color(0xFF262A33),
        onSurface: Color(0xFFE8EAEF),
        outline: Color(0xFF3A3F4B),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF1C1F26),
        foregroundColor: Color(0xFFE8EAEF),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF262A33),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF262A33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
