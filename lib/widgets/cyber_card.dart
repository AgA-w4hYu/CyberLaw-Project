import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// A reusable cyberpunk-styled card with optional neon glow border.
class CyberCard extends StatelessWidget {
  final Widget child;
  final Color? glowColor;
  final bool showGlow;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double borderRadius;

  const CyberCard({
    super.key,
    required this.child,
    this.glowColor,
    this.showGlow = false,
    this.padding,
    this.onTap,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final color = glowColor ?? AppTheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: AppTheme.cardGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: showGlow ? color : AppTheme.border,
            width: showGlow ? 1.5 : 1,
          ),
          boxShadow: showGlow ? AppTheme.neonGlow(color) : null,
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
