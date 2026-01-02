import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'theme_settings';
  static const String _themeKey = 'is_dark_mode';
  
  Box? _themeBox;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Colors matching the app icon - blue to cyan gradient
  static const Color _deepBlue = Color(0xFF1E5AA8); // Deep blue from icon
  static const Color _mediumBlue = Color(0xFF2B7DE9); // Medium blue from icon
  static const Color _brightCyan = Color(0xFF00D4FF); // Bright cyan from icon
  static const Color _lightCyan = Color(0xFF5DDBFF); // Light cyan from icon
  static const Color _darkBlue = Color(0xFF1A4C96); // Darker variant
  static const Color _softCyan = Color(0xFF87E8FF); // Softer cyan

  // Static gradient colors matching the icon exactly
  static const List<Color> gradientColors = [
    Color(0xFF1E5AA8), // Deep Blue (left side of icon)
    Color(0xFF2B7DE9), // Medium Blue
    Color(0xFF00D4FF), // Bright Cyan (right side of icon)
    Color(0xFF5DDBFF), // Light Cyan
    Color(0xFF87E8FF), // Soft Cyan
    Color(0xFF1A4C96), // Dark Blue variant
    Color(0xFF4FC3F7), // Sky Blue
    Color(0xFF29B6F6), // Light Blue
  ];

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _mediumBlue,
      brightness: Brightness.light,
      primary: _mediumBlue,
      secondary: _brightCyan,
      tertiary: _lightCyan,
      surface: const Color(0xFFFAFAFA),
      surfaceVariant: const Color(0xFFF5F5F5),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: Colors.transparent,
      foregroundColor: const Color(0xFF1A1A1A),
      titleTextStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A1A),
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.08),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 12,
      highlightElevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.white,
      selectedItemColor: _mediumBlue,
      unselectedItemColor: const Color(0xFF9E9E9E),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF3F4F6),
      selectedColor: _mediumBlue.withOpacity(0.1),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _mediumBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        color: Color(0xFF1A1A1A),
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: Color(0xFF1A1A1A),
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: Color(0xFF1A1A1A),
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF374151),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF6B7280),
      ),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _mediumBlue,
      brightness: Brightness.dark,
      primary: const Color(0xFF4FC3F7),
      secondary: const Color(0xFF00D4FF),
      tertiary: const Color(0xFF87E8FF),
      surface: const Color(0xFF1E1E1E),
      surfaceVariant: const Color(0xFF2A2A2A),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFF5F5F5),
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Color(0xFFF5F5F5),
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: const Color(0xFF1E1E1E),
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 12,
      highlightElevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFF4FC3F7),
      unselectedItemColor: Color(0xFF757575),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      selectedColor: const Color(0xFF4FC3F7).withOpacity(0.2),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFFF3F4F6),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF4FC3F7), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        color: Color(0xFFF5F5F5),
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: Color(0xFFF5F5F5),
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        color: Color(0xFFE0E0E0),
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFBDBDBD),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF9E9E9E),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF757575),
      ),
    ),
  );

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  Future<void> init() async {
    _themeBox = await Hive.openBox(_themeBoxName);
    _isDarkMode = _themeBox?.get(_themeKey, defaultValue: false) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _themeBox?.put(_themeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await _themeBox?.put(_themeKey, _isDarkMode);
      notifyListeners();
    }
  }

  // Gradient colors for charts and UI elements
  static List<Color> getGradientColors() => gradientColors;
  
  // Get specific gradient for different chart types - matching icon colors
  static LinearGradient getPrimaryGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E5AA8), // Deep Blue (left side of icon)
      Color(0xFF2B7DE9), // Medium Blue
      Color(0xFF00D4FF), // Bright Cyan (right side of icon)
    ],
  );

  static LinearGradient getSecondaryGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2B7DE9), // Medium Blue
      Color(0xFF5DDBFF), // Light Cyan
    ],
  );

  static LinearGradient getTertiaryGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00D4FF), // Bright Cyan
      Color(0xFF87E8FF), // Soft Cyan
    ],
  );

  // Background gradient matching the icon exactly
  static LinearGradient getBackgroundGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E5AA8), // Deep Blue
      Color(0xFF2B7DE9), // Medium Blue
      Color(0xFF00D4FF), // Bright Cyan
      Color(0xFF5DDBFF), // Light Cyan
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  // Chart gradient for area charts
  static LinearGradient getChartAreaGradient() => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF00D4FF), // Bright Cyan
      Color(0xFF87E8FF), // Soft Cyan
      Color(0xFFFFFFFF), // White (transparent)
    ],
    stops: [0.0, 0.5, 1.0],
  );
}