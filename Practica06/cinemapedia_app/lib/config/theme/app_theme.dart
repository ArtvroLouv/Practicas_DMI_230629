import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFFC46B),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF090A10),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF090A10),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
