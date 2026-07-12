import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';

class PasswordCheckerPage extends StatefulWidget {
  const PasswordCheckerPage({super.key});

  @override
  State<PasswordCheckerPage> createState() => _PasswordCheckerPageState();
}

class _PasswordCheckerPageState extends State<PasswordCheckerPage> {
  final _ctrl = TextEditingController();
  _PasswordResult? _result;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _check() {
    final pass = _ctrl.text;
    if (pass.isEmpty) return;
    setState(() => _result = _analyzePassword(pass));
  }

  _PasswordResult _analyzePassword(String p) {
    int score = 0;
    final checks = <_Check>[];

    final hasMin = p.length >= 8;
    checks.add(_Check('Minimal 8 karakter', hasMin));
    if (hasMin) score += 1;

    final hasLong = p.length >= 12;
    checks.add(_Check('Minimal 12 karakter (lebih baik)', hasLong));
    if (hasLong) score += 1;

    final hasUpper = p.contains(RegExp(r'[A-Z]'));
    checks.add(_Check('Huruf kapital (A-Z)', hasUpper));
    if (hasUpper) score += 1;

    final hasLower = p.contains(RegExp(r'[a-z]'));
    checks.add(_Check('Huruf kecil (a-z)', hasLower));
    if (hasLower) score += 1;

    final hasDigit = p.contains(RegExp(r'[0-9]'));
    checks.add(_Check('Angka (0-9)', hasDigit));
    if (hasDigit) score += 1;

    final hasSpecial = p.contains(RegExp(r'[^a-zA-Z0-9]'));
    checks.add(_Check('Karakter khusus (!@#\$...)', hasSpecial));
    if (hasSpecial) score += 2;

    final noRepeat = !RegExp(r'(.)\1{2,}').hasMatch(p);
    checks.add(_Check('Tidak ada pengulangan karakter', noRepeat));
    if (noRepeat) score += 1;

    String label;
    Color color;
    if (score <= 2) {
      label = 'SANGAT LEMAH';
      color = AppTheme.error;
    } else if (score <= 4) {
      label = 'LEMAH';
      color = AppTheme.accent;
    } else if (score <= 5) {
      label = 'SEDANG';
      color = AppTheme.warning;
    } else if (score <= 6) {
      label = 'KUAT';
      color = AppTheme.secondary;
    } else {
      label = 'SANGAT KUAT';
      color = AppTheme.primary;
    }

    return _PasswordResult(score: score, maxScore: 8, label: label, color: color, checks: checks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PASSWORD CHECKER')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cek seberapa kuat password Anda',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            CyberTextField(
              label: 'Masukkan Password',
              controller: _ctrl,
              obscureText: false,
              prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.textSecondary, size: 20),
              onChanged: (v) {
                if (v.isEmpty) setState(() => _result = null);
              },
            ),
            const SizedBox(height: 16),
            NeonButton(
              label: 'CEK KEKUATAN',
              width: double.infinity,
              onPressed: _check,
              icon: const Icon(Icons.security, size: 18, color: AppTheme.background),
            ),
            const SizedBox(height: 24),
            if (_result != null) _ResultPanel(result: _result!).animate().fadeIn().slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}

class _Check {
  final String label;
  final bool passed;
  const _Check(this.label, this.passed);
}

class _PasswordResult {
  final int score;
  final int maxScore;
  final String label;
  final Color color;
  final List<_Check> checks;

  const _PasswordResult({
    required this.score,
    required this.maxScore,
    required this.label,
    required this.color,
    required this.checks,
  });
}

class _ResultPanel extends StatelessWidget {
  final _PasswordResult result;
  const _ResultPanel({required this.result});

  @override
  Widget build(BuildContext context) {
    final progress = result.score / result.maxScore;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: result.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: result.color.withOpacity(0.5)),
            boxShadow: AppTheme.neonGlow(result.color, spread: 1),
          ),
          child: Column(
            children: [
              Text(result.label, style: GoogleFonts.orbitron(color: result.color, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppTheme.border,
                  valueColor: AlwaysStoppedAnimation<Color>(result.color),
                ),
              ),
              const SizedBox(height: 6),
              Text('Skor: ${result.score}/${result.maxScore}', style: TextStyle(color: result.color, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('DETAIL ANALISIS', style: GoogleFonts.orbitron(color: AppTheme.textSecondary, fontSize: 10, letterSpacing: 2)),
        const SizedBox(height: 10),
        ...result.checks.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                c.passed ? Icons.check_circle : Icons.cancel,
                color: c.passed ? AppTheme.secondary : AppTheme.error,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(c.label, style: TextStyle(color: c.passed ? AppTheme.textPrimary : AppTheme.textSecondary, fontSize: 14)),
            ],
          ),
        )),
      ],
    );
  }
}
