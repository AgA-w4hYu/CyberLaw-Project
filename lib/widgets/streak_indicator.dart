import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

/// A streak indicator showing daily login count with a fire icon.
class StreakIndicator extends StatelessWidget {
  final int streak;
  final double size;

  const StreakIndicator({
    super.key,
    required this.streak,
    this.size = 32,
  });

  Color get _color {
    if (streak >= 30) return AppColors.error;
    if (streak >= 7) return AppColors.warning;
    if (streak >= 3) return AppColors.primary;
    return AppColors.textTertiary;
  }

  String get _emoji {
    if (streak >= 30) return '🔥';
    if (streak >= 7) return '🔥';
    if (streak >= 3) return '🔥';
    return '🔥';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_fire_department,
          color: _color,
          size: size,
        ),
        const SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$streak',
              style: AppTypography.h4.copyWith(
                color: _color,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'day streak',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
