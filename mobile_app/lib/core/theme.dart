import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        // Add glassmorphism effects
        cardTheme: CardTheme(
          color: Colors.white.withOpacity(0.1),
          shadowColor: Colors.black.withOpacity(0.1),
        ),
      );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.black,
        cardTheme: CardTheme(
          color: Colors.white.withOpacity(0.1),
          shadowColor: Colors.white.withOpacity(0.1),
        ),
      );
}