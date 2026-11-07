import 'package:flutter/material.dart';

class Palette {
  static const bg = Color(0xFF0B1120);
  static const surface = Color(0xFF141F33);
  static const raised = Color(0xFF1D2B43);
  static const stroke = Color(0xFF2A3953);
  static const teal = Color(0xFF43E5CD);
  static const tealDark = Color(0xFF133E47);
  static const purple = Color(0xFFA499FF);
  static const white = Color(0xFFF4F8FF);
  static const muted = Color(0xFFA3B0C7);
  static const amber = Color(0xFFFFC978);
  static const red = Color(0xFFFF7792);
  static const green = Color(0xFF77DEB6);
}

ThemeData createTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Palette.bg,
    colorScheme: const ColorScheme.dark(
      primary: Palette.teal,
      secondary: Palette.purple,
      surface: Palette.surface,
      onSurface: Palette.white,
      error: Palette.red,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.2, color: Palette.white),
      headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.7, color: Palette.white),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Palette.white),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Palette.white),
      bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: Palette.white),
      bodyMedium: TextStyle(fontSize: 13, height: 1.55, color: Palette.muted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.bg,
      hintStyle: const TextStyle(color: Palette.muted),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Palette.stroke)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Palette.teal, width: 1.5)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      contentPadding: const EdgeInsets.all(16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: Palette.bg,
        backgroundColor: Palette.teal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.white,
        side: const BorderSide(color: Palette.stroke),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    dividerColor: Palette.stroke,
  );
}
