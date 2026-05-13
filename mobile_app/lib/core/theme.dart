import 'package:flutter/material.dart';

class AppTheme {
  // Tesla-inspired color palette
  static const Color backgroundBlack = Color(0xFF111111);
  static const Color surfaceGrey = Color(0xFF1C1C1E);
  static const Color accentNeon = Color(0xFF00E5FF); // Cyan
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF8E8E93);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBlack,
      primaryColor: accentNeon,
      fontFamily: 'Roboto', // Or 'SF Pro Display' if available
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: accentNeon,
        surface: surfaceGrey,
        background: backgroundBlack,
      ),
    );
  }
}