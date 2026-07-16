import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/achievement_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/streak_indicator.dart';
import '../../widgets/xp_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final unlockedAchievements = MockAchievementData.unlocked;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgPrimary,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Profile',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined,
                    color: AppColors.textTertiary),
                onPressed: () => context.push('/profile/settings'),
              ),
            ],
          ),

          // ── Content ──
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.page),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Avatar & Info
                _ProfileHeader(user: user),
                const SizedBox(height: AppSpacing.xxl),

                // XP & Streak
                _XpSection(),
                const SizedBox(height: AppSpacing.xxl),

                // Achievements
                _AchievementsSection(
                  achievements: unlockedAchievements,
                  totalCount: MockAchievementData.achievements.length,
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Statistics
                _StatisticsSection(),
                const SizedBox(height: AppSpacing.xxl),

                // Skill Tree
                _SkillTreeSection(),
                const SizedBox(height: AppSpacing.xxl),

                // Logout
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<AuthProvider>().logout();
                      context.go('/login');
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('LOG OUT'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error.withOpacity(0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.section),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Header ──
class _ProfileHeader extends StatelessWidget {
  final dynamic user;

  const _ProfileHeader({this.user});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          AvatarWidget(
            initials: user?.avatarInitials ?? '??',
            size: 64,
            showGlow: true,
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Cyber Student',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  user?.email ?? 'student@cyberlaw.id',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        borderRadius: AppSpacing.borderRadiusSm,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        'LEVEL 5',
                        style: AppTypography.overline.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${user?.score ?? 0} XP',
                      style: AppTypography.buttonSmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, curve: Curves.easeOut);
  }
}

// ── XP Section ──
class _XpSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        children: [
          Row(
            children: [
              const StreakIndicator(streak: 7),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: AppSpacing.borderRadiusSm,
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up,
                        color: AppColors.warning, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Next level in 320 XP',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          XpBar(currentXp: 180, maxXp: 500, level: 5),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }
}

// ── Achievements Section ──
class _AchievementsSection extends StatelessWidget {
  final List<Achievement> achievements;
  final int totalCount;

  const _AchievementsSection({
    required this.achievements,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Achievements'),
        const SizedBox(height: AppSpacing.md),
        Text(
          '${achievements.length} / $totalCount unlocked',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: achievements
              .map((a) => _AchievementBadge(achievement: a))
              .toList(),
        ),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement achievement;

  const _AchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${achievement.title}: ${achievement.description}',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: achievement.color.withOpacity(0.12),
          borderRadius: AppSpacing.borderRadiusSm,
          border: Border.all(
            color: achievement.isUnlocked
                ? achievement.color.withOpacity(0.4)
                : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              achievement.icon,
              color: achievement.isUnlocked
                  ? achievement.color
                  : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.title,
              style: AppTypography.overline.copyWith(
                color: achievement.isUnlocked
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Statistics Section ──
class _StatisticsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatItem(Icons.menu_book, 'Lessons', '12', AppColors.primary),
      _StatItem(Icons.flag_outlined, 'Challenges', '3', AppColors.secondary),
      _StatItem(Icons.build, 'Tools Used', '8', AppColors.warning),
      _StatItem(Icons.favorite, 'Likes', '47', AppColors.error),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Statistics'),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          padding: AppSpacing.cardPadding,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _statCard(stats[0])),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _statCard(stats[1])),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: _statCard(stats[2])),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _statCard(stats[3])),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard(_StatItem stat) {
    return Container(
      padding: AppSpacing.cardPaddingCompact,
      decoration: BoxDecoration(
        color: stat.color.withOpacity(0.06),
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(
          color: stat.color.withOpacity(0.15),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Icon(stat.icon, color: stat.color, size: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(
            stat.value,
            style: AppTypography.h3.copyWith(
              color: stat.color,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            stat.label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem(this.icon, this.label, this.value, this.color);
}

// ── Skill Tree Section ──
class _SkillTreeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final skills = [
      _SkillNode('Network', Icons.language, AppColors.primary, _SkillStatus.mastered),
      _SkillNode('Linux', Icons.terminal, AppColors.success, _SkillStatus.unlocked),
      _SkillNode('Python', Icons.code, AppColors.warning, _SkillStatus.locked),
      _SkillNode('Crypto', Icons.vpn_key, AppColors.secondary, _SkillStatus.unlocked),
      _SkillNode('Reverse', Icons.memory, AppColors.error, _SkillStatus.locked),
      _SkillNode('Web', Icons.web, AppColors.warning, _SkillStatus.locked),
      _SkillNode('Forensics', Icons.manage_search, AppColors.success, _SkillStatus.locked),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Skill Tree',
          actionLabel: 'View all',
          actionIcon: Icons.arrow_forward,
          onActionTap: () => context.push('/profile/skill-tree'),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: skills.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, i) => _SkillNodeCard(node: skills[i]),
          ),
        ),
      ],
    );
  }
}

enum _SkillStatus { locked, unlocked, mastered }

class _SkillNode {
  final String name;
  final IconData icon;
  final Color color;
  final _SkillStatus status;

  const _SkillNode(this.name, this.icon, this.color, this.status);
}

class _SkillNodeCard extends StatelessWidget {
  final _SkillNode node;

  const _SkillNodeCard({required this.node});

  @override
  Widget build(BuildContext context) {
    final isLocked = node.status == _SkillStatus.locked;
    final isMastered = node.status == _SkillStatus.mastered;

    return Container(
      width: 80,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isLocked
            ? AppColors.surface
            : node.color.withOpacity(0.08),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: isLocked
              ? AppColors.border
              : isMastered
                  ? AppColors.success.withOpacity(0.5)
                  : node.color.withOpacity(0.3),
          width: isMastered ? 1.5 : 0.5,
        ),
        boxShadow: isMastered
            ? [
                BoxShadow(
                  color: AppColors.success.withOpacity(0.2),
                  blurRadius: 8,
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isLocked ? Icons.lock_outline : node.icon,
            color: isLocked
                ? AppColors.textTertiary
                : isMastered
                    ? AppColors.success
                    : node.color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            node.name,
            style: AppTypography.overline.copyWith(
              color: isLocked
                  ? AppColors.textTertiary
                  : isMastered
                      ? AppColors.success
                      : AppColors.textPrimary,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
          if (isMastered)
            Text(
              'MASTERED',
              style: AppTypography.overline.copyWith(
                color: AppColors.success,
                fontSize: 7,
                letterSpacing: 0.5,
              ),
            ),
        ],
      ),
    );
  }
}
