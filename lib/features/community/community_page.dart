import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/community_post_model.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_header.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          // ── Trending Discussions ──
          SectionHeader(title: 'Trending'),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockCommunityData.trending.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) => _TrendingCard(post: MockCommunityData.trending[i]),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // ── Weekly Challenge ──
          _WeeklyChallengeCard(),
          const SizedBox(height: AppSpacing.xxl),

          // ── Mentor Picks ──
          SectionHeader(
            title: 'Mentor Picks',
            actionLabel: 'View all',
            onActionTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockCommunityData.mentorPicks.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) => _MentorPickCard(post: MockCommunityData.mentorPicks[i]),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // ── Find CTF Team ──
          _FindTeamCard(),
          const SizedBox(height: AppSpacing.xxl),

          // ── Leaderboard Preview ──
          _LeaderboardPreview(),
          const SizedBox(height: AppSpacing.xxl),

          // ── Popular Posts ──
          SectionHeader(
            title: 'Popular Posts',
            actionLabel: 'View all',
            onActionTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),

          // Filter chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip('All', true),
                _filterChip('CTF', false),
                _filterChip('Tutorial', false),
                _filterChip('Bug Bounty', false),
                _filterChip('Legal', false),
                _filterChip('Tools', false),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Posts
          ...MockCommunityData.posts.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _PostCard(post: p),
              )),
          const SizedBox(height: AppSpacing.section),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryBg : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.border,
              width: 0.5,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.buttonSmall.copyWith(
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Trending Card ──
class _TrendingCard extends StatelessWidget {
  final CommunityPost post;

  const _TrendingCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 240,
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              post.avatarColor.withOpacity(0.12),
              AppColors.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: post.avatarColor.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarWidget(
                  initials: post.avatarInitials,
                  size: 28,
                  color: post.avatarColor,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  post.username,
                  style: AppTypography.caption.copyWith(
                    color: post.avatarColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(Icons.local_fire_department,
                    color: AppColors.warning, size: 16),
              ],
            ),
            const Spacer(),
            Text(
              post.title,
              style: AppTypography.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.favorite, color: AppColors.error, size: 14),
                const SizedBox(width: 4),
                Text('${post.likes}', style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
                const SizedBox(width: AppSpacing.md),
                Icon(Icons.chat_bubble_outline, color: AppColors.textTertiary, size: 14),
                const SizedBox(width: 4),
                Text('${post.comments}', style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Weekly Challenge ──
class _WeeklyChallengeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.cardPadding,
      bgColor: AppColors.warningBg,
      borderColor: AppColors.warning.withOpacity(0.3),
      onTap: () {},
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.15),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: AppColors.warning,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Challenge',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Crack the Vigenère cipher and win 500 XP!',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.warning,
            size: 16,
          ),
        ],
      ),
    );
  }
}

// ── Mentor Pick Card ──
class _MentorPickCard extends StatelessWidget {
  final CommunityPost post;

  const _MentorPickCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 200,
        padding: AppSpacing.cardPaddingCompact,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.secondary, width: 2),
            left: BorderSide(color: AppColors.borderSoft),
            right: BorderSide(color: AppColors.borderSoft),
            bottom: BorderSide(color: AppColors.borderSoft),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarWidget(
                  initials: post.avatarInitials,
                  size: 24,
                  color: post.avatarColor,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    post.username,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              post.title,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${post.likes} likes',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Find Team Card ──
class _FindTeamCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.cardPadding,
      onTap: () {},
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: const Icon(
              Icons.group_add,
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
                  'Find CTF Team',
                  style: AppTypography.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Connect with teammates for upcoming competitions',
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
    );
  }
}

// ── Leaderboard Preview ──
class _LeaderboardPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Leaderboard',
          actionLabel: 'View full',
          actionIcon: Icons.arrow_forward,
          onActionTap: () => context.push('/community/leaderboard'),
        ),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          padding: AppSpacing.cardPadding,
          child: Column(
            children: [
              _leaderRow('🥇', 'kr4k3n_m4st3r', '4,250 XP', const Color(0xFFFFD60A)),
              const Divider(color: AppColors.border, height: AppSpacing.lg),
              _leaderRow('🥈', 'sec0ops_phantom', '3,875 XP', const Color(0xFF3B82F6)),
              const Divider(color: AppColors.border, height: AppSpacing.lg),
              _leaderRow('🥉', 'null_byte_ninja', '3,610 XP', const Color(0xFF10B981)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _leaderRow(String emoji, String name, String score, Color color) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            name,
            style: AppTypography.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          score,
          style: AppTypography.buttonSmall.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Post Card ──
class _PostCard extends StatefulWidget {
  final CommunityPost post;

  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.post;

    return GlassCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              AvatarWidget(
                initials: p.avatarInitials,
                size: 32,
                color: p.avatarColor,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.username,
                      style: AppTypography.body.copyWith(
                        color: p.avatarColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      p.timeAgo,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_horiz, color: AppColors.textTertiary, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Title
          Text(
            p.title,
            style: AppTypography.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Body
          Text(
            p.body,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),

          // Tags
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: p.tags
                .map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        '#$t',
                        style: AppTypography.overline.copyWith(
                          color: AppColors.primary,
                          fontSize: 9,
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.md),

          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _liked = !_liked),
                child: Row(
                  children: [
                    Icon(
                      _liked ? Icons.favorite : Icons.favorite_border,
                      color: _liked ? AppColors.error : AppColors.textTertiary,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${p.likes + (_liked ? 1 : 0)}',
                      style: AppTypography.caption.copyWith(
                        color:
                            _liked ? AppColors.error : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        color: AppColors.textTertiary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${p.comments}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.share_outlined,
                  color: AppColors.textTertiary, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
