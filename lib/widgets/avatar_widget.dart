import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

/// A premium avatar widget with optional gradient glow border.
class AvatarWidget extends StatelessWidget {
  final String initials;
  final double size;
  final Color? color;
  final bool showGlow;
  final String? imageUrl;

  const AvatarWidget({
    super.key,
    required this.initials,
    this.size = AppSpacing.avatarMd,
    this.color,
    this.showGlow = false,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = color ?? AppColors.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            avatarColor.withOpacity(0.2),
            avatarColor.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: showGlow ? avatarColor : avatarColor.withOpacity(0.3),
          width: showGlow ? 2 : 1,
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: avatarColor.withOpacity(0.3),
                  blurRadius: size * 0.4,
                  spreadRadius: size * 0.05,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        initials.substring(0, initials.length.clamp(0, 2)).toUpperCase(),
        style: AppTypography.button.copyWith(
          color: avatarColor,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
