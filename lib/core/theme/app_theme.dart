import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryPink = Color(0xFFFF69B4);
  static const Color secondaryBlue = Color(0xFF00BCD4);
  static const Color accentYellow = Color(0xFFFFD700);
  static const Color backgroundPurple = Color(0xFF6A1B9A);
  static const Color textWhite = Color(0xFFFAFAFA);
  static const Color buttonOrange = Color(0xFFFF9800);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryPink,
      scaffoldBackgroundColor: backgroundPurple,
      colorScheme: const ColorScheme.light(
        primary: primaryPink,
        secondary: secondaryBlue,
        surface: backgroundPurple,
      ),
      textTheme: GoogleFonts.bubblegumSansTextTheme().copyWith(
        displayLarge: const TextStyle(
          color: textWhite,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: const TextStyle(
          color: textWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: const TextStyle(
          color: textWhite,
          fontSize: 16,
        ),
        bodyMedium: const TextStyle(
          color: textWhite,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonOrange,
          foregroundColor: textWhite,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: textWhite,
        size: 24,
      ),
    );
  }
}
