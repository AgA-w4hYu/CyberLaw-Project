import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';

class PhishingCheckerPage extends StatefulWidget {
  const PhishingCheckerPage({super.key});

  @override
  State<PhishingCheckerPage> createState() => _PhishingCheckerPageState();
}

class _PhishingCheckerPageState extends State<PhishingCheckerPage> {
  final _ctrl = TextEditingController();
  _PhishResult? _result;
  bool _loading = false;

  final _suspiciousKeywords = ['login', 'secure', 'verify', 'account', 'update', 'confirm', 'banking', 'paypal', 'ebay', 'amazon', 'microsoft', 'google', 'apple', 'netflix'];
  final _suspiciousTLDs = ['.xyz', '.tk', '.ml', '.ga', '.cf', '.gq', '.top', '.click', '.download', '.loan', '.work'];

  Future<void> _check() async {
    final url = _ctrl.text.trim().toLowerCase();
    if (url.isEmpty) return;

    setState(() { _loading = true; _result = null; });
    await Future.delayed(const Duration(milliseconds: 800));

    final indicators = <_Indicator>[];
    int riskScore = 0;

    // HTTPS check
    final hasHttps = url.startsWith('https://');
    indicators.add(_Indicator('Menggunakan HTTPS', hasHttps, hasHttps ? 0 : 2));
    if (!hasHttps) riskScore += 2;

    // Suspicious TLD
    final hasSuspTld = _suspiciousTLDs.any((tld) => url.contains(tld));
    indicators.add(_Indicator('Ekstensi domain mencurigakan', !hasSuspTld, hasSuspTld ? 3 : 0));
    if (hasSuspTld) riskScore += 3;

    // IP address as domain
    final hasIp = RegExp(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}').hasMatch(url);
    indicators.add(_Indicator('Menggunakan IP sebagai domain', !hasIp, hasIp ? 4 : 0));
    if (hasIp) riskScore += 4;

    // Suspicious keywords
    final foundKeywords = _suspiciousKeywords.where((k) => url.contains(k)).toList();
    final hasKeywords = foundKeywords.isNotEmpty;
    indicators.add(_Indicator('Mengandung kata kunci sensitif (${foundKeywords.take(2).join(', ')})', !hasKeywords, hasKeywords ? 2 : 0));
    if (hasKeywords) riskScore += 2;

    // Excessive subdomains
    final domainPart = url.replaceAll(RegExp(r'https?://'), '').split('/').first;
    final dotCount = '.'.allMatches(domainPart).length;
    final excessiveSubs = dotCount > 2;
    indicators.add(_Indicator('Jumlah subdomain wajar', !excessiveSubs, excessiveSubs ? 2 : 0));
    if (excessiveSubs) riskScore += 2;

    // Long URL
    final tooLong = url.length > 75;
    indicators.add(_Indicator('Panjang URL normal (<75 karakter)', !tooLong, tooLong ? 1 : 0));
    if (tooLong) riskScore += 1;

    String verdict;
    Color color;
    String advice;
    if (riskScore == 0) {
      verdict = 'AMAN';
      color = AppTheme.secondary;
      advice = 'URL ini terlihat aman. Tetap waspada terhadap konten halaman.';
    } else if (riskScore <= 3) {
      verdict = 'PERHATIAN';
      color = AppTheme.warning;
      advice = 'URL ini memiliki beberapa karakteristik mencurigakan. Berhati-hatilah sebelum memasukkan data pribadi.';
    } else {
      verdict = 'BERISIKO TINGGI';
      color = AppTheme.error;
      advice = 'URL ini menunjukkan banyak tanda phishing. JANGAN klik atau masukkan data apapun!';
    }

    setState(() {
      _result = _PhishResult(verdict: verdict, color: color, advice: advice, indicators: indicators, riskScore: riskScore);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PHISHING CHECKER')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analisis URL untuk mendeteksi tanda-tanda phishing secara heuristik.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 20),
            CyberTextField(
              label: 'Masukkan URL',
              hint: 'https://example.com',
              controller: _ctrl,
              keyboardType: TextInputType.url,
              prefixIcon: const Icon(Icons.link, color: AppTheme.textSecondary, size: 20),
            ),
            const SizedBox(height: 16),
            NeonButton(
              label: 'SCAN URL',
              width: double.infinity,
              isLoading: _loading,
              onPressed: _check,
              color: AppTheme.accent,
              useGradient: false,
              icon: const Icon(Icons.radar, size: 18, color: Colors.white),
            ),
            const SizedBox(height: 24),
            if (_result != null) _ResultWidget(result: _result!).animate().fadeIn().slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}

class _Indicator {
  final String label;
  final bool safe;
  final int riskPoints;
  const _Indicator(this.label, this.safe, this.riskPoints);
}

class _PhishResult {
  final String verdict;
  final Color color;
  final String advice;
  final List<_Indicator> indicators;
  final int riskScore;
  const _PhishResult({required this.verdict, required this.color, required this.advice, required this.indicators, required this.riskScore});
}

class _ResultWidget extends StatelessWidget {
  final _PhishResult result;
  const _ResultWidget({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: result.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: result.color.withOpacity(0.5)),
            boxShadow: AppTheme.neonGlow(result.color, spread: 1),
          ),
          child: Column(
            children: [
              Icon(
                result.riskScore == 0 ? Icons.verified_user : (result.riskScore <= 3 ? Icons.warning_amber : Icons.dangerous),
                color: result.color, size: 36,
              ),
              const SizedBox(height: 10),
              Text(result.verdict, style: GoogleFonts.orbitron(color: result.color, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 8),
              Text(result.advice, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('DETAIL ANALISIS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2)),
        const SizedBox(height: 10),
        ...result.indicators.map((ind) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(ind.safe ? Icons.check_circle : Icons.cancel, color: ind.safe ? AppTheme.secondary : AppTheme.error, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(ind.label, style: TextStyle(color: ind.safe ? AppTheme.textPrimary : AppTheme.textSecondary, fontSize: 13))),
            ],
          ),
        )),
      ],
    );
  }
}
