import 'package:flutter/material.dart';

class AegisTheme {
  // 1. Bảng màu (Tesla Dark Style)
  static const Color primaryBlack = Color(0xFF000000);
  static const Color secondaryBlack = Color(0xFF111111);
  static const Color accentBlue = Color(0xFF00E5FF); // Neon Cyan
  static const Color accentGreen = Color(0xFF00E676); // Success
  static const Color accentRed = Color(0xFFFF3D00); // Danger
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF8E8E93);

  // 2. Kích thước khoảng cách (Spacing)
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;

  // 3. Bo góc (Border Radius)
  static const double radiusLarge = 24.0;

  // 4. Kiểu chữ (Text Styles)
  static const TextStyle headlineSmall = TextStyle(
    color: textWhite,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
  );

  static const TextStyle bodyMuted = TextStyle(
    color: textMuted,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // 5. Cấu hình Theme tổng thể cho MaterialApp
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: secondaryBlack,
      primaryColor: accentBlue,
      fontFamily: 'Roboto', 
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        surface: secondaryBlack,
        background: primaryBlack,
        error: accentRed,
      ),
    );
  }
}