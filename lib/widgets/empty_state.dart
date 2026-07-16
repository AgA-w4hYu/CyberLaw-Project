import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

/// An encouraging empty state widget with icon and message.
/// Never says "No Data" — always gives a positive prompt.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? color;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.color,
  });

  /// Predefined empty states
  factory EmptyState.noFavorites() => const EmptyState(
        icon: Icons.favorite_border,
        title: 'No favorite tools yet',
        subtitle: 'Explore the toolkit and star your favorites!',
      );

  factory EmptyState.noLessons() => const EmptyState(
        icon: Icons.menu_book,
        title: 'Start your learning journey',
        subtitle: 'Complete your first lesson to begin.',
      );

  factory EmptyState.noChallenges() => const EmptyState(
        icon: Icons.flag_outlined,
        title: 'Enter the CTF Arena',
        subtitle: 'No challenges solved yet. Ready for your first flag?',
      );

  factory EmptyState.noCommunity() => const EmptyState(
        icon: Icons.forum,
        title: 'Join your first discussion',
        subtitle: 'Be the change you want to see in the community.',
      );

  factory EmptyState.noResults() => const EmptyState(
        icon: Icons.search_off,
        title: 'No results found',
        subtitle: 'Try a different search term.',
      );

  factory EmptyState.welcome() => const EmptyState(
        icon: Icons.shield_outlined,
        title: 'Welcome to CyberLaw!',
        subtitle: 'Start your cybersecurity journey today.',
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: (color ?? AppColors.primary).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: color ?? AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              title,
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
