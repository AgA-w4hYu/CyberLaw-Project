import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// A reusable glassmorphism card widget with blur effect.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double borderRadius;
  final Color? borderColor;
  final Color? bgColor;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.borderRadius = AppSpacing.radiusMd,
    this.borderColor,
    this.bgColor,
    this.onTap,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding ?? AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.glassBg,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? AppColors.glassBorder,
            width: 0.5,
          ),
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}
