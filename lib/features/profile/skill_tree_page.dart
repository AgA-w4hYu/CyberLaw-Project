import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/glass_card.dart';

class SkillTreePage extends StatelessWidget {
  const SkillTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Tree')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          Text(
            'Master each skill to unlock the next',
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Skill Tree Cards
          _SkillCard(
            name: 'Network Security',
            icon: Icons.language,
            color: AppColors.primary,
            status: 'MASTERED',
            progress: 1.0,
            description: 'TCP/IP, firewalls, network scanning',
          ),
          const SizedBox(height: AppSpacing.md),

          _SkillCard(
            name: 'Linux Fundamentals',
            icon: Icons.terminal,
            color: AppColors.success,
            status: 'IN PROGRESS',
            progress: 0.6,
            description: 'CLI, permissions, shell scripting',
          ),
          const SizedBox(height: AppSpacing.md),

          _SkillCard(
            name: 'Cryptography',
            icon: Icons.vpn_key,
            color: AppColors.secondary,
            status: 'IN PROGRESS',
            progress: 0.3,
            description: 'Symmetric, asymmetric, hashing',
          ),
          const SizedBox(height: AppSpacing.md),

          _SkillCard(
            name: 'Python Programming',
            icon: Icons.code,
            color: AppColors.warning,
            status: 'LOCKED',
            progress: 0.0,
            description: 'Complete Network Security to unlock',
            locked: true,
          ),
          const SizedBox(height: AppSpacing.md),

          _SkillCard(
            name: 'Web Security',
            icon: Icons.web,
            color: AppColors.warning,
            status: 'LOCKED',
            progress: 0.0,
            description: 'Complete Linux & Cryptography to unlock',
            locked: true,
          ),
          const SizedBox(height: AppSpacing.md),

          _SkillCard(
            name: 'Reverse Engineering',
            icon: Icons.memory,
            color: AppColors.error,
            status: 'LOCKED',
            progress: 0.0,
            description: 'Complete Python to unlock',
            locked: true,
          ),
          const SizedBox(height: AppSpacing.md),

          _SkillCard(
            name: 'Digital Forensics',
            icon: Icons.manage_search,
            color: AppColors.success,
            status: 'LOCKED',
            progress: 0.0,
            description: 'Complete Web Security to unlock',
            locked: true,
          ),
          const SizedBox(height: AppSpacing.section),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String status;
  final double progress;
  final String description;
  final bool locked;

  const _SkillCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.status,
    required this.progress,
    required this.description,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.cardPadding,
      borderColor: locked
          ? AppColors.border
          : status == 'MASTERED'
              ? AppColors.success.withOpacity(0.4)
              : color.withOpacity(0.3),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: locked
                  ? AppColors.surface
                  : color.withOpacity(0.12),
              borderRadius: AppSpacing.borderRadiusSm,
              border: Border.all(
                color: locked
                    ? AppColors.border
                    : status == 'MASTERED'
                        ? AppColors.success.withOpacity(0.3)
                        : color.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Icon(
              locked ? Icons.lock_outline : icon,
              color: locked
                  ? AppColors.textTertiary
                  : status == 'MASTERED'
                      ? AppColors.success
                      : color,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: AppTypography.h4.copyWith(
                        color: locked
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: status == 'MASTERED'
                            ? AppColors.successBg
                            : status == 'IN PROGRESS'
                                ? color.withOpacity(0.12)
                                : AppColors.surface,
                        borderRadius: AppSpacing.borderRadiusSm,
                        border: Border.all(
                          color: status == 'MASTERED'
                              ? AppColors.success.withOpacity(0.3)
                              : status == 'IN PROGRESS'
                                  ? color.withOpacity(0.3)
                                  : AppColors.border,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        status,
                        style: AppTypography.overline.copyWith(
                          color: status == 'MASTERED'
                              ? AppColors.success
                              : status == 'IN PROGRESS'
                                  ? color
                                  : AppColors.textTertiary,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                if (progress > 0) ...[
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 4,
                      color: AppColors.border,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withOpacity(0.7)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, curve: Curves.easeOut);
  }
}
