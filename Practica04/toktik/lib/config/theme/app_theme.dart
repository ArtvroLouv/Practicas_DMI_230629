import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta principal exclusiva: Cyber Sunset & Obsidian
  static const Color background = Color(0xFF08090C);
  static const Color surface = Color(0xFF10121A);
  static const Color primary = Color(0xFFFF3366); // Fucsia Neón
  static const Color secondary = Color(0xFF00E5FF); // Cian Neón
  static const Color accent = Color(0xFFFF9900); // Ámbar Fuego

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      surface: surface,
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    ),
  );
}
