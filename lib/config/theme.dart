import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryLight = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color accentLight = Color(0xFF03A9F4);
  static const Color accentDark = Color(0xFF0288D1);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryLight,
    colorScheme: ColorScheme.light(
      primary: primaryLight,
      secondary: accentLight,
      surface: Colors.white,
      background: Colors.grey[50]!,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    colorScheme: ColorScheme.dark(
      primary: primaryDark,
      secondary: accentDark,
      surface: Colors.grey[900]!,
      background: Colors.black,
      error: Colors.red[300]!,
    ),
    scaffoldBackgroundColor: Colors.black,
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    ),
  );
}
