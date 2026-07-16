import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

/// An animated XP progress bar with gradient fill.
class XpBar extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final int level;
  final bool showLabel;

  const XpBar({
    super.key,
    required this.currentXp,
    required this.maxXp,
    required this.level,
    this.showLabel = true,
  });

  double get _progress => maxXp > 0 ? (currentXp / maxXp).clamp(0.0, 1.0) : 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Row(
            children: [
              Text(
                'LEVEL $level',
                style: AppTypography.label.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Text(
                '$currentXp / $maxXp XP',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        if (showLabel) const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _progress),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.xpGradientColors,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
