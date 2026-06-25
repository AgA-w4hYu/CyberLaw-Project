import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  static const _entries = [
    _LeaderEntry(rank: 1, username: 'kr4k3n_m4st3r', score: 4250, country: '🇮🇩', badge: '💀', solvedCount: 42, avatarColor: Color(0xFFFFD60A)),
    _LeaderEntry(rank: 2, username: 'sec0ops_phantom', score: 3875, country: '🇮🇩', badge: '🔮', solvedCount: 38, avatarColor: Color(0xFF00F0FF)),
    _LeaderEntry(rank: 3, username: 'null_byte_ninja', score: 3610, country: '🇸🇬', badge: '⚔️', solvedCount: 35, avatarColor: Color(0xFF00FF9C)),
    _LeaderEntry(rank: 4, username: 'void_walker99', score: 2990, country: '🇮🇩', badge: '🛡️', solvedCount: 29, avatarColor: Color(0xFFAB00FF)),
    _LeaderEntry(rank: 5, username: 'binary_ghost', score: 2745, country: '🇲🇾', badge: '👁️', solvedCount: 27, avatarColor: Color(0xFFFF006E)),
    _LeaderEntry(rank: 6, username: 'shellcode_sam', score: 2430, country: '🇮🇩', badge: '⚡', solvedCount: 24, avatarColor: Color(0xFF00B4D8)),
    _LeaderEntry(rank: 7, username: 'pwnageTech', score: 2100, country: '🇵🇭', badge: '🔑', solvedCount: 21, avatarColor: Color(0xFFFF8700)),
    _LeaderEntry(rank: 8, username: 'zero_day_zeta', score: 1870, country: '🇮🇩', badge: '🎯', solvedCount: 18, avatarColor: Color(0xFF39D353)),
    _LeaderEntry(rank: 9, username: 'hacktivist_h4', score: 1650, country: '🇮🇩', badge: '🌐', solvedCount: 16, avatarColor: Color(0xFFA78BFA)),
    _LeaderEntry(rank: 10, username: 'cipherBreaker', score: 1420, country: '🇹🇭', badge: '💻', solvedCount: 14, avatarColor: Color(0xFFFACC15)),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('LEADERBOARD')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top 3 podium
          _PodiumSection(entries: _entries.take(3).toList()).animate().fadeIn(),
          const SizedBox(height: 20),

          // Current user rank card
          if (currentUser != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0D2137), AppTheme.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Text('Kamu', style: TextStyle(color: AppTheme.primary, fontSize: 12)),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: AppTheme.primary.withOpacity(0.2),
                    radius: 16,
                    child: Text(currentUser.avatarInitials, style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(currentUser.name, style: GoogleFonts.rajdhani(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.bold))),
                  Text('${currentUser.score} pts', style: const TextStyle(color: AppTheme.warning, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text('#${currentUser.rank}', style: TextStyle(color: AppTheme.primary.withOpacity(0.7), fontSize: 13)),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),

          Text('TOP 10', style: GoogleFonts.orbitron(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 3)),
          const SizedBox(height: 12),
          ..._entries.asMap().entries.map((e) => _LeaderRow(entry: e.value, index: e.key)),
        ],
      ),
    );
  }
}

class _LeaderEntry {
  final int rank;
  final String username;
  final int score;
  final String country;
  final String badge;
  final int solvedCount;
  final Color avatarColor;

  const _LeaderEntry({
    required this.rank, required this.username, required this.score,
    required this.country, required this.badge, required this.solvedCount,
    required this.avatarColor,
  });
}

class _PodiumSection extends StatelessWidget {
  final List<_LeaderEntry> entries;
  const _PodiumSection({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.length < 3) return const SizedBox.shrink();
    final ranks = [entries[1], entries[0], entries[2]]; // 2nd, 1st, 3rd
    final heights = [80.0, 108.0, 60.0];
    final medals = ['🥈', '🥇', '🥉'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(3, (i) {
        final e = ranks[i];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                Text(medals[i], style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                CircleAvatar(
                  backgroundColor: e.avatarColor.withOpacity(0.2),
                  radius: 22,
                  child: Text(e.username.substring(0, 2).toUpperCase(), style: TextStyle(color: e.avatarColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
                Text(e.username.length > 12 ? '${e.username.substring(0, 10)}...' : e.username, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 11), textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text('${e.score}', style: GoogleFonts.orbitron(color: e.avatarColor, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  height: heights[i],
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [e.avatarColor.withOpacity(0.3), e.avatarColor.withOpacity(0.1)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    border: Border.all(color: e.avatarColor.withOpacity(0.4)),
                  ),
                  alignment: Alignment.center,
                  child: Text('#${e.rank}', style: GoogleFonts.orbitron(color: e.avatarColor, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _LeaderRow extends StatelessWidget {
  final _LeaderEntry entry;
  final int index;

  const _LeaderRow({required this.entry, required this.index});

  Color get _rankColor {
    if (entry.rank == 1) return const Color(0xFFFFD60A);
    if (entry.rank == 2) return const Color(0xFFBDC3C7);
    if (entry.rank == 3) return const Color(0xFFCD7F32);
    return AppTheme.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: entry.rank <= 3 ? entry.avatarColor.withOpacity(0.3) : AppTheme.border),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text('#${entry.rank}', style: GoogleFonts.orbitron(color: _rankColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: entry.avatarColor.withOpacity(0.15),
              radius: 16,
              child: Text(entry.username.substring(0, 2).toUpperCase(), style: TextStyle(color: entry.avatarColor, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(entry.badge, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(entry.username, style: GoogleFonts.rajdhani(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Text(entry.country, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  Text('${entry.solvedCount} challenge selesai', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                ],
              ),
            ),
            Text('${entry.score}', style: GoogleFonts.orbitron(color: AppTheme.warning, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(begin: 0.05),
    );
  }
}
