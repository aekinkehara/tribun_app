import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromARGB(255, 254, 144, 26);
  static const Color secondary = Color.fromARGB(255, 70, 190, 255);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.black;
  static const Color onBackground = Color(0xFF121212);
  static const Color onSurface = Color(0xFF121212);
  static const Color onError = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Additional colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color cardShadow = Color(0x1A000000);

  // dark mode colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkPrimaryText = Colors.white;
  static const Color darkSecondaryText = Color(0xFFBDBDBD);
  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color darkCardShadow = Color(0x33000000);

  // helper methods biar gampang dipanggil
  static Color backgroundColor(bool isDark) =>
      isDark ? darkBackground : background;

  static Color surfaceColor(bool isDark) =>
      isDark ? darkSurface : surface;

  static Color textColor(bool isDark) =>
      isDark ? darkPrimaryText : textPrimary;

  static Color subtextColor(bool isDark) =>
      isDark ? darkSecondaryText : textSecondary;

  static Color dividerColor(bool isDark) =>
      isDark ? darkDivider : divider;
}
