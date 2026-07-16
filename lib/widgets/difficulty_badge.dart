import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

/// A badge showing difficulty level with appropriate color.
class DifficultyBadge extends StatelessWidget {
  final String difficulty;
  final double fontSize;

  const DifficultyBadge({
    super.key,
    required this.difficulty,
    this.fontSize = 10,
  });

  Color get _color {
    switch (difficulty.toLowerCase()) {
      case 'easy':
      case 'beginner':
        return AppColors.difficultyEasy;
      case 'medium':
      case 'intermediate':
        return AppColors.difficultyMedium;
      case 'hard':
      case 'advanced':
        return AppColors.difficultyHard;
      default:
        return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: _color.withOpacity(0.4),
          width: 0.5,
        ),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: AppTypography.overline.copyWith(
          color: _color,
          fontSize: fontSize,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
