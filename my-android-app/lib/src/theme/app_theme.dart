import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  // 2026 Design System Colors
  static const Color _primary = Color(0xFF6C63FF); // Electric Purple
  static const Color _secondary = Color(0xFF00BFA5); // Cyan Accent
  static const Color _background = Color(0xFFF0F4F8); // Cool White/Grey
  static const Color _surface = Colors.white;
  static const Color _darkSurface = Color(0xFF1E1E2E);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFFF48FB1)], // Purple to Pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark-mode header gradient: deeper + less neon for night readability.
  static const LinearGradient darkHeaderGradient = LinearGradient(
    colors: [Color(0xFF1B2235), Color(0xFF3D2C8D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient headerGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkHeaderGradient : primaryGradient;
  }

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00BFA5), Color(0xFF64FFDA)], // Teal to Mint
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Colors.white70, Colors.white30],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF6C63FF).withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.plusJakartaSansTextTheme(base);
  }

  static ThemeData lightTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primary,
        primary: _primary,
        secondary: _secondary,
        background: _background,
        surface: _surface,
      ),
      scaffoldBackgroundColor: _background,
      textTheme: _buildTextTheme(base.textTheme),

      // Card Theme (Glass-like base)
      cardTheme: CardThemeData(
        elevation: 0,
        color: _surface.withOpacity(0.8),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
        ),
      ),

      // AppBar Theme (Transparent/Gradient handled in widgets)
      appBarTheme: const AppBarThemeData(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1E1E2E), // Dark Text
        elevation: 0,
        centerTitle: true,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 10,
        shape: CircleBorder(), // Classic round but high elevation
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: _primary.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),

      // Navigation Bar Theme (Modern Pill Style)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surface,
        elevation: 0,
        indicatorColor: _primary.withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: _primary, size: 28);
          }
          return const IconThemeData(color: Colors.grey, size: 24);
        }),
      ),
    );
  }

  static ThemeData darkTheme() {
    final ThemeData base = ThemeData.dark();

    const darkBackground = Color(0xFF0F1117);
    const darkSurface = Color(0xFF151A23);

    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      primary: _primary,
      secondary: _secondary,
      background: darkBackground,
      surface: darkSurface,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: darkBackground,
      textTheme: _buildTextTheme(base.textTheme),

      cardTheme: CardThemeData(
        elevation: 0,
        color: darkSurface.withOpacity(0.92),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.outlineVariant.withOpacity(0.6), width: 1),
        ),
      ),

      appBarTheme: AppBarThemeData(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 10,
        shape: const CircleBorder(),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 8,
          shadowColor: scheme.primary.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        elevation: 0,
        indicatorColor: scheme.primary.withOpacity(0.18),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: scheme.primary, size: 28);
          }
          return IconThemeData(color: scheme.onSurfaceVariant, size: 24);
        }),
      ),
    );
  }
}
