import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/learning_path_model.dart';
import '../../widgets/difficulty_badge.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_header.dart';

/// Placeholder snackbar for routes not yet implemented
void _showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Coming soon!'),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ),
  );
}

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.page,
              bottom: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppSpacing.borderRadiusSm,
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: TabBar(
              controller: _tabCtrl,
              indicator: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: AppSpacing.borderRadiusSm,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textTertiary,
              labelStyle: AppTypography.buttonSmall,
              unselectedLabelStyle: AppTypography.buttonSmall,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Learning Paths'),
                Tab(text: 'CTF Arena'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _LearningPathsTab(),
          _CtfArenaTab(),
        ],
      ),
    );
  }
}

// ── Learning Paths Tab ──
class _LearningPathsTab extends StatelessWidget {
  final List<LearningPath> paths = MockLearningData.paths;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.page),
      itemCount: paths.length + 1, // +1 for section header
      itemBuilder: (ctx, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Text(
              'Choose a path to start learning',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }
        final path = paths[i - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _PathCard(path: path),
        );
      },
    );
  }
}

// ── Learning Path Card ──
class _PathCard extends StatelessWidget {
  final LearningPath path;

  const _PathCard({required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showComingSoon(context),
      child: GlassCard(
        padding: AppSpacing.cardPadding,
        borderColor: path.color.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: path.color.withOpacity(0.12),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: Icon(path.icon, color: path.color, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        path.title,
                        style: AppTypography.h4.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          DifficultyBadge(difficulty: path.difficultyLabel),
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.schedule,
                            color: AppColors.textTertiary,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${path.estimatedHours}h',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.menu_book,
                            color: AppColors.textTertiary,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${path.totalLessons} lessons',
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
            const SizedBox(height: AppSpacing.md),
            Text(
              path.description,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 4,
                color: AppColors.border,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: path.progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [path.color, path.color.withOpacity(0.7)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  '${path.completedLessons}/${path.totalLessons} completed',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const Spacer(),
                if (path.hasBadge)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: AppSpacing.borderRadiusSm,
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: AppColors.success,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: AppTypography.overline.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: 400.ms,
          curve: Curves.easeOut,
        ).slideX(begin: 0.05, curve: Curves.easeOut);
  }
}

// ── CTF Arena Tab ──
class _CtfArenaTab extends StatefulWidget {
  @override
  State<_CtfArenaTab> createState() => _CtfArenaTabState();
}

class _CtfArenaTabState extends State<_CtfArenaTab> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Search bar
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.page,
            AppSpacing.page,
            AppSpacing.sm,
          ),
          sliver: SliverToBoxAdapter(
            child: TextField(
              controller: _searchCtrl,
              style: AppTypography.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search challenges...',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.textTertiary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusSm,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusSm,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusSm,
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
        ),

        // Filter chips
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(label: 'All', selected: true),
                  _FilterChip(label: 'Easy', selected: false),
                  _FilterChip(label: 'Medium', selected: false),
                  _FilterChip(label: 'Hard', selected: false),
                  _FilterChip(label: 'Crypto', selected: false),
                  _FilterChip(label: 'Web', selected: false),
                  _FilterChip(label: 'Forensics', selected: false),
                  _FilterChip(label: 'Reverse', selected: false),
                ],
              ),
            ),
          ),
        ),

        const SliverPadding(
          padding: EdgeInsets.only(top: AppSpacing.xl),
        ),

        // Challenge cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Featured challenges header
              SectionHeader(
                title: 'Featured',
                actionLabel: 'View all',
                onActionTap: () {},
              ),
              const SizedBox(height: AppSpacing.lg),
              _ChallengeCard(
                title: 'Crypto Challenge 01',
                category: 'Cryptography',
                difficulty: 'Easy',
                xp: 100,
                time: '15 min',
                tags: ['Caesar Cipher', 'ROT13'],
                color: const Color(0xFF8B5CF6),
              ),
              const SizedBox(height: AppSpacing.md),
              _ChallengeCard(
                title: 'Forensic Analysis 01',
                category: 'Forensics',
                difficulty: 'Medium',
                xp: 200,
                time: '30 min',
                tags: ['File Analysis', 'Steganography'],
                color: const Color(0xFF10B981),
              ),
              const SizedBox(height: AppSpacing.md),
              _ChallengeCard(
                title: 'Web Security 01',
                category: 'Web Security',
                difficulty: 'Easy',
                xp: 150,
                time: '20 min',
                tags: ['XSS', 'JavaScript'],
                color: const Color(0xFFF59E0B),
              ),
              const SizedBox(height: AppSpacing.md),
              _ChallengeCard(
                title: 'Reverse Engineering 01',
                category: 'Reverse Eng.',
                difficulty: 'Hard',
                xp: 300,
                time: '45 min',
                tags: ['Assembly', 'Debugging'],
                color: const Color(0xFFEF4444),
                solved: true,
              ),
              const SizedBox(height: AppSpacing.section),
            ]),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(              onTap: () => _showComingSoon(context),
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

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String category;
  final String difficulty;
  final int xp;
  final String time;
  final List<String> tags;
  final Color color;
  final bool solved;

  const _ChallengeCard({
    required this.title,
    required this.category,
    required this.difficulty,
    required this.xp,
    required this.time,
    required this.tags,
    required this.color,
    this.solved = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: GlassCard(
        padding: AppSpacing.cardPadding,
        borderColor: solved
            ? AppColors.success.withOpacity(0.4)
            : color.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.h4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (solved)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: AppSpacing.borderRadiusSm,
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'SOLVED',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                DifficultyBadge(difficulty: difficulty),
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.star, color: AppColors.warning, size: 14),
                const SizedBox(width: 4),
                Text(
                  '$xp XP',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.schedule, color: AppColors.textTertiary, size: 14),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              category,
              style: AppTypography.bodySm.copyWith(
                color: color,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: tags
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.08),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                          border: Border.all(
                            color: color.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          t,
                          style: AppTypography.overline.copyWith(
                            color: color,
                            fontSize: 9,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
