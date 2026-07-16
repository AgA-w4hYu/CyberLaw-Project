import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/cyber_news_model.dart';
import '../../models/learning_path_model.dart';
import '../../models/tool_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/streak_indicator.dart';
import '../../widgets/xp_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: AppColors.bgPrimary,
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                AvatarWidget(
                  initials: user?.avatarInitials ?? '??',
                  size: 36,
                  showGlow: true,
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Good ${_timeOfDay()}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      user?.name ?? 'Hacker',
                      style: AppTypography.bodyLg.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                ),
                onPressed: () {
                  // TODO: Global search
                },
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),

          // ── Content ──
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.page),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // XP & Streak Row
                _XpStreakRow(user: user),

                const SizedBox(height: AppSpacing.xxl),

                // Continue Learning
                if (user != null && user.solvedChallenges.isNotEmpty)
                  _ContinueLearningCard()
                else
                  _StartLearningCard(),

                const SizedBox(height: AppSpacing.xl),

                // Today's Mission
                const _TodaysMission(),
                const SizedBox(height: AppSpacing.xxl),

                // Recent Activity
                const _RecentActivity(),
                const SizedBox(height: AppSpacing.xxl),

                // Recommended Tool
                const _RecommendedTool(),
                const SizedBox(height: AppSpacing.xxl),

                // Today's Security Tip
                const _SecurityTip(),
                const SizedBox(height: AppSpacing.xxl),

                // Latest Cyber News
                const _CyberNews(),
                const SizedBox(height: AppSpacing.section),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _timeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

// ── XP & Streak Row ──
class _XpStreakRow extends StatelessWidget {
  final dynamic user;
  const _XpStreakRow({this.user});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              const StreakIndicator(streak: 7),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBg,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      'LEVEL 5',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.secondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text(
                        '${user?.score ?? 0}',
                        style: AppTypography.h3.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'XP',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          XpBar(
            currentXp: (user?.score ?? 0) % 500,
            maxXp: 500,
            level: 5,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut);
  }
}

// ── Continue Learning ──
class _ContinueLearningCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      bgColor: AppColors.primaryBg,
      borderColor: AppColors.primary.withOpacity(0.3),
      onTap: () => context.go('/learn'),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: const Icon(
              Icons.play_circle_fill,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Continue Learning',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Network Security - TCP/IP Protocol',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 16,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut);
  }
}

// ── Start Learning (for new users) ──
class _StartLearningCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      bgColor: AppColors.primaryBg,
      borderColor: AppColors.primary.withOpacity(0.3),
      onTap: () => context.go('/learn'),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: const Icon(
              Icons.school,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Your Journey',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Begin with Network Security or Cryptography',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 16,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut);
  }
}

// ── Today's Mission ──
class _TodaysMission extends StatelessWidget {
  const _TodaysMission();

  @override
  Widget build(BuildContext context) {
    final missions = [
      _Mission('Complete one lesson', Icons.menu_book, AppColors.primary, false),
      _Mission('Solve a CTF challenge', Icons.flag_outlined, AppColors.secondary, true),
      _Mission('Read today\'s security tip', Icons.lightbulb_outline, AppColors.warning, false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "Today's Mission"),
        const SizedBox(height: AppSpacing.lg),
        ...missions.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _MissionTile(mission: e.value, index: e.key),
            )),
      ],
    );
  }
}

class _Mission {
  final String label;
  final IconData icon;
  final Color color;
  final bool completed;

  const _Mission(this.label, this.icon, this.color, this.completed);
}

class _MissionTile extends StatelessWidget {
  final _Mission mission;
  final int index;

  const _MissionTile({required this.mission, required this.index});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.cardPadding,
      onTap: () {},
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mission.completed
                  ? AppColors.success
                  : Colors.transparent,
              border: Border.all(
                color: mission.completed
                    ? AppColors.success
                    : AppColors.border,
                width: 2,
              ),
            ),
            child: mission.completed
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Icon(mission.icon, color: mission.color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              mission.label,
              style: AppTypography.body.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          delay: Duration(milliseconds: 300 + index * 80),
          duration: 300.ms,
        );
  }
}

// ── Recent Activity ──
class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    final activities = [
      _Activity(Icons.menu_book, AppColors.primary, 'Completed TCP/IP lesson', '2 hours ago'),
      _Activity(Icons.flag, AppColors.secondary, 'Solved Crypto Challenge 01', '1 day ago'),
      _Activity(Icons.build, AppColors.warning, 'Used Password Strength Tool', '2 days ago'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Activity',
          actionLabel: 'View all',
          onActionTap: () {},
        ),
        const SizedBox(height: AppSpacing.lg),
        ...activities.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassCard(
                padding: AppSpacing.cardPaddingCompact,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: a.color.withOpacity(0.1),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Icon(a.icon, color: a.color, size: 18),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.title,
                            style: AppTypography.body.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            a.time,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class _Activity {
  final IconData icon;
  final Color color;
  final String title;
  final String time;

  const _Activity(this.icon, this.color, this.title, this.time);
}

// ── Recommended Tool ──
class _RecommendedTool extends StatelessWidget {
  const _RecommendedTool();

  @override
  Widget build(BuildContext context) {
    final tool = MockToolData.popular.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Recommended Tool'),
        const SizedBox(height: AppSpacing.lg),
        GlassCard(
          padding: AppSpacing.cardPadding,
          bgColor: AppColors.secondaryBg,
          borderColor: AppColors.secondary.withOpacity(0.3),
          onTap: () => context.go('/toolkit'),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(tool.icon, color: tool.color, size: 28),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.name,
                      style: AppTypography.h4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tool.description,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.secondary,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Security Tip ──
class _SecurityTip extends StatelessWidget {
  const _SecurityTip();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: "Today's Security Tip"),
        const SizedBox(height: AppSpacing.lg),
        GlassCard(
          padding: AppSpacing.cardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: AppColors.warning,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enable 2FA everywhere',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Two-factor authentication adds an extra layer of security beyond just a password. Use authenticator apps instead of SMS when possible.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Cyber News ──
class _CyberNews extends StatelessWidget {
  const _CyberNews();

  @override
  Widget build(BuildContext context) {
    final news = MockNewsData.news.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Cyber News',
          actionLabel: 'More',
          onActionTap: () {},
        ),
        const SizedBox(height: AppSpacing.lg),
        ...news.map((n) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: GlassCard(
                padding: AppSpacing.cardPaddingCompact,
                onTap: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: n.color.withOpacity(0.1),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Icon(n.icon, color: n.color, size: 16),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            n.title,
                            style: AppTypography.body.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Text(
                                n.source,
                                style: AppTypography.overline.copyWith(
                                  color: n.color,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                n.timeAgo,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
