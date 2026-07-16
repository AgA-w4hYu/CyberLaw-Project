import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/glass_card.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  static const _entries = [
    _Entry(rank: 1, name: 'kr4k3n_m4st3r', score: 4250, xp: '4,250', color: Color(0xFFFFD60A)),
    _Entry(rank: 2, name: 'sec0ops_phantom', score: 3875, xp: '3,875', color: Color(0xFF3B82F6)),
    _Entry(rank: 3, name: 'null_byte_ninja', score: 3610, xp: '3,610', color: Color(0xFF10B981)),
    _Entry(rank: 4, name: 'void_walker99', score: 2990, xp: '2,990', color: Color(0xFF8B5CF6)),
    _Entry(rank: 5, name: 'binary_ghost', score: 2745, xp: '2,745', color: Color(0xFFEC4899)),
    _Entry(rank: 6, name: 'shellcode_sam', score: 2430, xp: '2,430', color: Color(0xFF06B6D4)),
    _Entry(rank: 7, name: 'pwnageTech', score: 2100, xp: '2,100', color: Color(0xFFF59E0B)),
    _Entry(rank: 8, name: 'zero_day_zeta', score: 1870, xp: '1,870', color: Color(0xFFEF4444)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          // Podium
          _Podium(entries: _entries.take(3).toList()),
          const SizedBox(height: AppSpacing.xxl),

          // Top 8 list
          Text(
            'TOP 8',
            style: AppTypography.label.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ..._entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _LeaderRow(entry: e),
              )),
        ],
      ),
    );
  }
}

class _Entry {
  final int rank;
  final String name;
  final int score;
  final String xp;
  final Color color;

  const _Entry({
    required this.rank,
    required this.name,
    required this.score,
    required this.xp,
    required this.color,
  });
}

// ── Podium ──
class _Podium extends StatelessWidget {
  final List<_Entry> entries;

  const _Podium({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.length < 3) return const SizedBox.shrink();
    // Arrange: 2nd, 1st, 3rd
    final arranged = [entries[1], entries[0], entries[2]];
    final heights = [80.0, 100.0, 60.0];
    final medals = ['🥈', '🥇', '🥉'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final e = arranged[i];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(medals[i], style: const TextStyle(fontSize: 24)),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: e.color.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: e.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    e.name.substring(0, 2).toUpperCase(),
                    style: AppTypography.button.copyWith(color: e.color),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  e.name.length > 10
                      ? '${e.name.substring(0, 8)}...'
                      : e.name,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  e.xp,
                  style: AppTypography.buttonSmall.copyWith(
                    color: e.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: heights[i],
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        e.color.withOpacity(0.3),
                        e.color.withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSpacing.radiusSm),
                    ),
                    border: Border.all(
                      color: e.color.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#${e.rank}',
                    style: AppTypography.h4.copyWith(
                      color: e.color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// ── Leader Row ──
class _LeaderRow extends StatelessWidget {
  final _Entry entry;

  const _LeaderRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.cardPaddingCompact,
      borderColor: entry.color.withOpacity(0.2),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '#${entry.rank}',
              style: AppTypography.buttonSmall.copyWith(
                color: entry.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: entry.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              entry.name.substring(0, 2).toUpperCase(),
              style: AppTypography.buttonSmall.copyWith(color: entry.color),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              entry.name,
              style: AppTypography.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            entry.xp,
            style: AppTypography.buttonSmall.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
