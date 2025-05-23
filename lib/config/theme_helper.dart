import 'package:flutter/material.dart';

class ThemeHelper {
  // Primary colors
  static const Color primaryLight = Color(0xFF2196F3); // Material Blue
  static const Color primaryDark = Color(0xFF1976D2); // Darker Blue
  static const Color secondaryLight = Color(0xFF03A9F4); // Light Blue
  static const Color secondaryDark = Color(0xFF0288D1); // Darker Light Blue

  // Accent colors
  static const Color accentLight = Color(0xFF00BCD4); // Cyan
  static const Color accentDark = Color(0xFF0097A7); // Darker Cyan

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F5F5); // Light Gray
  static const Color backgroundDark = Color(0xFF121212); // Dark Gray
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E); // Darker Gray

  // Text colors
  static const Color textPrimaryLight = Color(0xFF212121); // Dark Gray
  static const Color textSecondaryLight = Color(0xFF757575); // Medium Gray
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFB0B0B0); // Light Gray

  // Error colors
  static const Color errorLight = Color(0xFFE57373); // Light Red
  static const Color errorDark = Color(0xFFD32F2F); // Dark Red

  // Success colors
  static const Color successLight = Color(0xFF81C784); // Light Green
  static const Color successDark = Color(0xFF388E3C); // Dark Green

  // Gradients
  static List<Color> get primaryGradient => [primaryLight, primaryDark];
  static List<Color> get secondaryGradient => [secondaryLight, secondaryDark];
  static List<Color> get accentGradient => [accentLight, accentDark];
  static List<Color> get errorGradient => [errorLight, errorDark];
  static List<Color> get successGradient => [successLight, successDark];

  // Get gradient
  static LinearGradient getGradient(
    List<Color> colors, {
    bool isVertical = false,
    double opacity = 1.0,
  }) {
    return LinearGradient(
      colors: colors.map((color) => color.withOpacity(opacity)).toList(),
      begin: isVertical ? Alignment.topCenter : Alignment.centerLeft,
      end: isVertical ? Alignment.bottomCenter : Alignment.centerRight,
    );
  }

  // Get gradient decoration
  static BoxDecoration getGradientDecoration(
    List<Color> colors, {
    bool isVertical = false,
    double opacity = 1.0,
  }) {
    return BoxDecoration(
      gradient: getGradient(colors, isVertical: isVertical, opacity: opacity),
    );
  }

  // Get card decoration
  static BoxDecoration getCardDecoration({
    List<Color>? gradientColors,
    bool isVertical = false,
    double opacity = 1.0,
    double borderRadius = 12.0,
  }) {
    return BoxDecoration(
      gradient: gradientColors != null
          ? getGradient(gradientColors,
              isVertical: isVertical, opacity: opacity)
          : null,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Get placeholder decoration
  static BoxDecoration getPlaceholderDecoration({
    double borderRadius = 12.0,
  }) {
    return BoxDecoration(
      color: Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  // Get theme data
  static ThemeData getThemeData(bool isDarkMode) {
    final colorScheme = ColorScheme(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: isDarkMode ? primaryDark : primaryLight,
      onPrimary: Colors.white,
      secondary: isDarkMode ? secondaryDark : secondaryLight,
      onSecondary: Colors.white,
      tertiary: isDarkMode ? accentDark : accentLight,
      onTertiary: Colors.white,
      error: isDarkMode ? errorDark : errorLight,
      onError: Colors.white,
      background: isDarkMode ? backgroundDark : backgroundLight,
      onBackground: isDarkMode ? textPrimaryDark : textPrimaryLight,
      surface: isDarkMode ? surfaceDark : surfaceLight,
      onSurface: isDarkMode ? textPrimaryDark : textPrimaryLight,
      surfaceVariant: isDarkMode
          ? surfaceDark.withOpacity(0.8)
          : surfaceLight.withOpacity(0.8),
      onSurfaceVariant: isDarkMode ? textSecondaryDark : textSecondaryLight,
      outline: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
      outlineVariant: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: colorScheme.surface,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
    );
  }
}
