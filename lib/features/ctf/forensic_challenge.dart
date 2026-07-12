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

class _GenericChallengeState extends State<_GenericChallenge> {
  final _flagCtrl = TextEditingController();
  bool _showHint = false;
  bool _solved = false;
  bool _wrongFlag = false;

  @override
  void dispose() { _flagCtrl.dispose(); super.dispose(); }

  void _submit() {
    final input = _flagCtrl.text.trim();
    if (input.isEmpty) return;
    if (input == widget.challenge.flag) {
      final auth = context.read<AuthProvider>();
      if (!(auth.currentUser?.solvedChallenges.contains(widget.challenge.id) ?? false)) {
        auth.markChallengeSolved(widget.challenge.id, widget.challenge.points);
      }
      setState(() { _solved = true; _wrongFlag = false; });
    } else {
      setState(() => _wrongFlag = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alreadySolved = context.watch<AuthProvider>().currentUser?.solvedChallenges.contains(widget.challenge.id) ?? false;
    return Scaffold(
      appBar: AppBar(title: Text(widget.challenge.category.toUpperCase())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: widget.color.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(widget.challenge.title, style: GoogleFonts.orbitron(color: widget.color, fontSize: 15, fontWeight: FontWeight.bold))),
                  DifficultyBadge(difficulty: widget.challenge.difficulty),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 20),
            const Text('SOAL', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2)),
            const SizedBox(height: 10),
            TerminalText(text: widget.challenge.description, color: widget.color).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() => _showHint = !_showHint),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.warning.withOpacity(0.4)),
                ),
                child: Row(children: [
                  const Icon(Icons.lightbulb_outline, color: AppTheme.warning, size: 18),
                  const SizedBox(width: 8),
                  const Text('Petunjuk', style: TextStyle(color: AppTheme.warning, fontSize: 13, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Icon(_showHint ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppTheme.warning),
                ]),
              ),
            ),
            if (_showHint) Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                child: Text(widget.challenge.hint, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
              ).animate().fadeIn().slideY(begin: -0.1),
            ),
            const SizedBox(height: 24),
            if (_solved || alreadySolved)
              Container(
                width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.secondary), boxShadow: AppTheme.neonGlow(AppTheme.secondary),
                ),
                child: Column(children: [
                  const Icon(Icons.emoji_events, color: AppTheme.secondary, size: 40),
                  const SizedBox(height: 10),
                  Text('SELESAI! +${widget.challenge.points} pts', style: GoogleFonts.orbitron(color: AppTheme.secondary, fontSize: 15, fontWeight: FontWeight.bold)),
                ]),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack)
            else ...[
              CyberTextField(label: 'Masukkan Flag', hint: 'flag{...}', controller: _flagCtrl, prefixIcon: const Icon(Icons.flag, color: AppTheme.textSecondary, size: 20)),
              if (_wrongFlag) Padding(
                padding: const EdgeInsets.only(top: 8),
                child: const Row(children: [Icon(Icons.close, color: AppTheme.error, size: 16), SizedBox(width: 6), Text('Flag salah. Coba lagi!', style: TextStyle(color: AppTheme.error, fontSize: 13))]).animate().shake(),
              ),
              const SizedBox(height: 16),
              NeonButton(label: 'SUBMIT FLAG', width: double.infinity, onPressed: _submit, color: widget.color, useGradient: false),
            ],
          ],
        ),
      ),
    );
  }
}

class _GenericChallenge extends StatefulWidget {
  final CtfChallengeModel challenge;
  final Color color;
  const _GenericChallenge({required this.challenge, required this.color});
  @override
  State<_GenericChallenge> createState() => _GenericChallengeState();
}

// ───── Exported challenge pages ─────

class ForensicChallenge extends StatelessWidget {
  final CtfChallengeModel? challenge;
  const ForensicChallenge({super.key, this.challenge});
  @override
  Widget build(BuildContext context) {
    final c = challenge ?? CtfData.challenges.firstWhere((c) => c.category == 'forensic');
    return _GenericChallenge(challenge: c, color: AppTheme.secondary);
  }
}

class WebChallenge extends StatelessWidget {
  final CtfChallengeModel? challenge;
  const WebChallenge({super.key, this.challenge});
  @override
  Widget build(BuildContext context) {
    final c = challenge ?? CtfData.challenges.firstWhere((c) => c.category == 'web');
    return _GenericChallenge(challenge: c, color: AppTheme.warning);
  }
}

class ReverseChallenge extends StatelessWidget {
  final CtfChallengeModel? challenge;
  const ReverseChallenge({super.key, this.challenge});
  @override
  Widget build(BuildContext context) {
    final c = challenge ?? CtfData.challenges.firstWhere((c) => c.category == 'reverse');
    return _GenericChallenge(challenge: c, color: AppTheme.accent);
  }
}
