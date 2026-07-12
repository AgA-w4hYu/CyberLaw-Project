import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/ctf_challenge_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';
import '../../widgets/common_widgets.dart';

/// Web Security challenge — presents client-side vulnerability puzzles
/// that the user must identify and decode to find the flag.
class WebChallenge extends StatefulWidget {
  final CtfChallengeModel? challenge;
  const WebChallenge({super.key, this.challenge});

  @override
  State<WebChallenge> createState() => _WebChallengeState();
}

class _WebChallengeState extends State<WebChallenge> {
  final _flagCtrl = TextEditingController();
  bool _showHint = false;
  bool _solved = false;
  bool _wrongFlag = false;

  late final CtfChallengeModel _challenge =
      widget.challenge ?? CtfData.challenges.firstWhere((c) => c.id == 'web-01');

  @override
  void dispose() {
    _flagCtrl.dispose();
    super.dispose();
  }

  void _submitFlag() {
    final input = _flagCtrl.text.trim();
    if (input.isEmpty) return;

    if (input == _challenge.flag) {
      final auth = context.read<AuthProvider>();
      if (!auth.currentUser!.solvedChallenges.contains(_challenge.id)) {
        auth.markChallengeSolved(_challenge.id, _challenge.points);
      }
      setState(() {
        _solved = true;
        _wrongFlag = false;
      });
    } else {
      setState(() => _wrongFlag = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSolvedBefore =
        context.read<AuthProvider>().currentUser?.solvedChallenges.contains(_challenge.id) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WEB SECURITY'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.warning),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, color: AppTheme.warning, size: 14),
                SizedBox(width: 4),
                Text('WEB', style: TextStyle(color: AppTheme.warning, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challenge header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1500), AppTheme.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.warning.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _challenge.title,
                          style: GoogleFonts.orbitron(color: AppTheme.warning, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DifficultyBadge(difficulty: _challenge.difficulty),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.warning, size: 14),
                      const SizedBox(width: 4),
                      Text('${_challenge.points} pts', style: const TextStyle(color: AppTheme.warning, fontSize: 12)),
                      const SizedBox(width: 12),
                      const Icon(Icons.language, color: AppTheme.warning, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'WEB SECURITY',
                        style: const TextStyle(color: AppTheme.warning, fontSize: 12, letterSpacing: 1),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(),

            // What is Web Security challenge?
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.warning, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Web security challenge = mengidentifikasi kerentanan sisi klien (cookie, header, injection) pada aplikasi web.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.4),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 50.ms),

            const SizedBox(height: 20),
            const Text('SOAL', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2)),
            const SizedBox(height: 10),
            _buildWebTerminal(_challenge.description),
            const SizedBox(height: 20),

            // Hint
            GestureDetector(
              onTap: () => setState(() => _showHint = !_showHint),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.warning.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppTheme.warning, size: 18),
                    const SizedBox(width: 8),
                    const Text('Petunjuk', style: TextStyle(color: AppTheme.warning, fontSize: 13, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Icon(_showHint ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppTheme.warning),
                  ],
                ),
              ),
            ),
            if (_showHint)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(_challenge.hint, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
                ).animate().fadeIn().slideY(begin: -0.1),
              ),
            const SizedBox(height: 24),

            // Result
            if (_solved || isSolvedBefore)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.secondary),
                  boxShadow: AppTheme.neonGlow(AppTheme.secondary),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events, color: AppTheme.secondary, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      'CHALLENGE SELESAI!',
                      style: GoogleFonts.orbitron(color: AppTheme.secondary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text('+${_challenge.points} points ditambahkan ke akun kamu!',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack)
            else ...[
              const Text('SUBMIT FLAG', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2)),
              const SizedBox(height: 8),
              const Text('Format: flag{...}', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              const SizedBox(height: 8),
              CyberTextField(
                label: 'Masukkan Flag',
                hint: 'flag{...}',
                controller: _flagCtrl,
                prefixIcon: const Icon(Icons.flag, color: AppTheme.textSecondary, size: 20),
              ),
              if (_wrongFlag)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: const Row(
                    children: [
                      Icon(Icons.close, color: AppTheme.error, size: 16),
                      SizedBox(width: 6),
                      Text('Flag salah. Coba lagi!', style: TextStyle(color: AppTheme.error, fontSize: 13)),
                    ],
                  ).animate().shake(),
                ),
              const SizedBox(height: 16),
              NeonButton(
                label: 'SUBMIT FLAG',
                width: double.infinity,
                onPressed: _submitFlag,
                color: AppTheme.warning,
                useGradient: false,
                icon: const Icon(Icons.send, size: 16, color: AppTheme.background),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWebTerminal(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF010409),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
      ),
      child: SelectableText(
        text,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: AppTheme.warning,
          letterSpacing: 0.5,
          height: 1.6,
        ),
      ),
    ).animate().fadeIn(delay: 100.ms);
  }
}
