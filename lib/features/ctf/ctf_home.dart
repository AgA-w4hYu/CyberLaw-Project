import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/ctf_challenge_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class CtfHome extends StatelessWidget {
  final String category;
  const CtfHome({super.key, required this.category});

  List<CtfChallengeModel> get _challenges =>
      CtfData.challenges.where((c) => c.category == category).toList();

  String get _title {
    switch (category) {
      case 'crypto': return 'CRYPTOGRAPHY';
      case 'forensic': return 'FORENSICS';
      case 'web': return 'WEB SECURITY';
      case 'reverse': return 'REVERSE ENG.';
      default: return category.toUpperCase();
    }
  }

  String get _route {
    switch (category) {
      case 'crypto': return AppConstants.routeCryptoChallenge;
      case 'forensic': return AppConstants.routeForensicChallenge;
      case 'web': return AppConstants.routeWebChallenge;
      case 'reverse': return AppConstants.routeReverseChallenge;
      default: return AppConstants.routeCryptoChallenge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final solvedIds = context.watch<AuthProvider>().currentUser?.solvedChallenges ?? [];
    final challenges = _challenges;

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: challenges.isEmpty
          ? const Center(child: Text('Belum ada tantangan tersedia', style: TextStyle(color: AppTheme.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: challenges.length,
              itemBuilder: (ctx, i) {
                final c = challenges[i];
                final solved = solvedIds.contains(c.id);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => context.push(_route, extra: c),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: solved ? AppTheme.secondary.withOpacity(0.5) : AppTheme.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: solved ? AppTheme.secondary.withOpacity(0.15) : AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              solved ? Icons.check_circle : Icons.flag,
                              color: solved ? AppTheme.secondary : AppTheme.textSecondary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.title, style: GoogleFonts.rajdhani(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    DifficultyBadge(difficulty: c.difficulty),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.star, color: AppTheme.warning, size: 13),
                                    const SizedBox(width: 3),
                                    Text('${c.points} pts', style: const TextStyle(color: AppTheme.warning, fontSize: 12)),
                                    if (solved) ...[
                                      const SizedBox(width: 8),
                                      const Text('✓ Selesai', style: TextStyle(color: AppTheme.secondary, fontSize: 12)),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 20),
                        ],
                      ),
                    ).animate(delay: Duration(milliseconds: 80 * i)).fadeIn().slideX(begin: 0.1),
                  ),
                );
              },
            ),
    );
  }
}
