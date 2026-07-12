import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  Color get _color {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.secondary;
      case 'medium':
        return AppTheme.warning;
      case 'hard':
        return AppTheme.accent;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color, width: 1),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          color: _color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class CyberDivider extends StatelessWidget {
  final Color? color;
  const CyberDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            (color ?? AppTheme.primary).withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class GlowIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const GlowIcon({super.key, required this.icon, required this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(icon, color: color.withOpacity(0.3), size: size + 8),
        Icon(icon, color: color, size: size),
      ],
    );
  }
}

class TerminalText extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;

  const TerminalText({super.key, required this.text, this.color, this.fontSize = 13});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF010409),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: SelectableText(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: fontSize,
          color: color ?? AppTheme.secondary,
          letterSpacing: 0.5,
          height: 1.6,
        ),
      ),
    );
  }
}
