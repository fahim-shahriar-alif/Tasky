import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'theme_settings';
  static const String _themeKey = 'is_dark_mode';
  
  Box? _themeBox;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Modern blue/purple gradient colors from the provided image
  static const Color _primaryBlue = Color(0xFF4C63D2); // Deep blue from image
  static const Color _primaryPurple = Color(0xFF5A67D8); // Rich purple-blue
  static const Color _accentBlue = Color(0xFF667EEA); // Lighter blue
  static const Color _lightBlue = Color(0xFF9F7AEA); // Light purple-blue
  static const Color _softBlue = Color(0xFFBBD5FF); // Very light blue
  static const Color _darkBlue = Color(0xFF3C4FE0); // Dark blue

  // Gradient colors matching the blue theme from image
  static const List<Color> gradientColors = [
    Color(0xFF4C63D2), // Deep Blue (primary from image)
    Color(0xFF5A67D8), // Purple Blue
    Color(0xFF667EEA), // Indigo Blue
    Color(0xFF7C3AED), // Purple
    Color(0xFF8B5CF6), // Light Purple
    Color(0xFF9F7AEA), // Lavender
    Color(0xFFBBD5FF), // Light Blue
    Color(0xFF3C4FE0), // Dark Blue
  ];

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryBlue,
      brightness: Brightness.light,
      primary: _primaryBlue,
      secondary: _accentBlue,
      tertiary: _lightBlue,
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
      selectedItemColor: _primaryBlue,
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
      selectedColor: _primaryBlue.withOpacity(0.1),
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
        borderSide: const BorderSide(color: _primaryBlue, width: 2),
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
      seedColor: _primaryBlue,
      brightness: Brightness.dark,
      primary: const Color(0xFF7C3AED),
      secondary: const Color(0xFF8B5CF6),
      tertiary: const Color(0xFF9F7AEA),
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
      selectedItemColor: Color(0xFF7C3AED),
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
      selectedColor: const Color(0xFF7C3AED).withOpacity(0.2),
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
        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
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
  
  // Get specific gradient for different chart types
  static LinearGradient getPrimaryGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4C63D2), // Deep Blue
      Color(0xFF5A67D8), // Purple Blue
    ],
  );

  static LinearGradient getSecondaryGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667EEA), // Indigo Blue
      Color(0xFF7C3AED), // Purple
    ],
  );

  static LinearGradient getTertiaryGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B5CF6), // Light Purple
      Color(0xFF9F7AEA), // Lavender
    ],
  );

  // Background gradient matching the blue theme
  static LinearGradient getBackgroundGradient() => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4C63D2), // Deep Blue
      Color(0xFF5A67D8), // Purple Blue
      Color(0xFF667EEA), // Indigo Blue
      Color(0xFF7C3AED), // Purple
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  // Chart gradient for area charts
  static LinearGradient getChartAreaGradient() => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF667EEA), // Indigo Blue
      Color(0xFF9F7AEA), // Lavender
      Color(0xFFFFFFFF), // White (transparent)
    ],
    stops: [0.0, 0.5, 1.0],
  );
}