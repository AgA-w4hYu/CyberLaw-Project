import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core Colors
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceVariant = Color(0xFF21262D);
  static const Color primary = Color(0xFF00F0FF);
  static const Color secondary = Color(0xFF00FF9C);
  static const Color accent = Color(0xFFFF006E);
  static const Color warning = Color(0xFFFFD60A);
  static const Color error = Color(0xFFFF453A);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color border = Color(0xFF30363D);

  // Gradient presets
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F0FF), Color(0xFF00FF9C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF161B22), Color(0xFF0D1117)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF006E), Color(0xFF8B00FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Neon glow shadows
  static List<BoxShadow> neonGlow(Color color, {double spread = 4}) => [
        BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, spreadRadius: spread),
        BoxShadow(color: color.withOpacity(0.2), blurRadius: 24, spreadRadius: spread * 2),
      ];

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          secondary: secondary,
          surface: surface,
          error: error,
          onPrimary: background,
          onSecondary: background,
          onSurface: textPrimary,
        ),
        textTheme: GoogleFonts.rajdhaniTextTheme().copyWith(
          displayLarge: GoogleFonts.orbitron(
            color: textPrimary, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2,
          ),
          displayMedium: GoogleFonts.orbitron(
            color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5,
          ),
          displaySmall: GoogleFonts.orbitron(
            color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1,
          ),
          headlineLarge: GoogleFonts.rajdhani(
            color: textPrimary, fontSize: 22, fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.rajdhani(
            color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.rajdhani(color: textPrimary, fontSize: 16),
          bodyMedium: GoogleFonts.rajdhani(color: textSecondary, fontSize: 14),
          labelLarge: GoogleFonts.rajdhani(
            color: background, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surface,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.orbitron(
            color: primary, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2,
          ),
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: border, width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
          labelStyle: GoogleFonts.rajdhani(color: textSecondary),
          hintStyle: GoogleFonts.rajdhani(color: textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: primary,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        dividerTheme: const DividerThemeData(color: border, thickness: 1),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: surfaceVariant,
          contentTextStyle: GoogleFonts.rajdhani(color: textPrimary, fontSize: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surfaceVariant,
          selectedColor: primary.withOpacity(0.2),
          labelStyle: GoogleFonts.rajdhani(color: textPrimary),
          side: const BorderSide(color: border),
        ),
      );
}
