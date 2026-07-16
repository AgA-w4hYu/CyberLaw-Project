import 'package:flutter/material.dart';

/// Design system color tokens for CyberLaw.
/// Modern, premium dark theme with deep navy, blue and purple accents.
class AppColors {
  // ── Background ──
  static const Color bgPrimary = Color(0xFF0A0E21);
  static const Color bgSecondary = Color(0xFF111827);
  static const Color bgTertiary = Color(0xFF1C1F33);

  // ── Surface ──
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceHover = Color(0xFF263548);
  static const Color surfaceElevated = Color(0xFF273549);
  static const Color surfaceCard = Color(0xFF1E293B);

  // ── Brand / Primary ──
  static const Color primary = Color(0xFF3B82F6);
  static const Color primarySoft = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF2563EB);
  static Color primaryBg = const Color(0xFF3B82F6).withOpacity(0.10);

  // ── Brand / Secondary ──
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondarySoft = Color(0xFFA78BFA);
  static const Color secondaryDark = Color(0xFF7C3AED);
  static Color secondaryBg = const Color(0xFF8B5CF6).withOpacity(0.10);

  // ── Semantic ──
  static const Color success = Color(0xFF10B981);
  static Color successBg = const Color(0xFF10B981).withOpacity(0.10);
  static const Color warning = Color(0xFFF59E0B);
  static Color warningBg = const Color(0xFFF59E0B).withOpacity(0.10);
  static const Color error = Color(0xFFEF4444);
  static Color errorBg = const Color(0xFFEF4444).withOpacity(0.10);
  static const Color info = Color(0xFF3B82F6);
  static Color infoBg = const Color(0xFF3B82F6).withOpacity(0.10);

  // ── Text ──
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textInverse = Color(0xFF0A0E21);

  // ── Border ──
  static const Color border = Color(0xFF334155);
  static Color borderSoft = Colors.white.withOpacity(0.06);

  // ── Glassmorphism ──
  static Color glassBg = Colors.white.withOpacity(0.05);
  static Color glassBorder = Colors.white.withOpacity(0.08);
  static const double glassBlur = 20.0;

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientH = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF111827)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ── XP Bar Colors ──
  static const List<Color> xpGradientColors = [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
  ];

  // ── Difficulty Colors ──
  static const Color difficultyEasy = Color(0xFF10B981);
  static const Color difficultyMedium = Color(0xFFF59E0B);
  static const Color difficultyHard = Color(0xFFEF4444);

  // ── Skill Tree Node Colors ──
  static const Color skillLocked = Color(0xFF374151);
  static const Color skillUnlocked = Color(0xFF3B82F6);
  static const Color skillMastered = Color(0xFF8B5CF6);
}
