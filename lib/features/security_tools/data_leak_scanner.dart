import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../widgets/cyber_text_field.dart';
import '../../widgets/neon_button.dart';

class DataLeakScannerPage extends StatefulWidget {
  const DataLeakScannerPage({super.key});

  @override
  State<DataLeakScannerPage> createState() => _DataLeakScannerPageState();
}

class _DataLeakScannerPageState extends State<DataLeakScannerPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isScanning = false;
  bool _hasResult = false;
  List<Map<String, dynamic>> _breaches = [];
  
  // Matrix effect lines
  final List<String> _scanLogs = [];
  Timer? _scanTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  void _startScan() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan email terlebih dahulu'), backgroundColor: AppTheme.error),
      );
      return;
    }

    setState(() {
      _isScanning = true;
      _hasResult = false;
      _breaches = [];
      _scanLogs.clear();
    });

    _simulateScan(email);
  }

  Future<void> _simulateScan(String email) async {
    final List<String> fakeLogs = [
      'INITIALIZING SECURE CONNECTION...',
      'BYPASSING FIREWALL...',
      'ACCESSING DARK WEB DATABASES...',
      'SEARCHING KEPPO_DB_2021...',
      'SEARCHING TOKO_ONLINE_LEAK_2020...',
      'DECRYPTING HASHED RECORDS...',
      'CROSS-REFERENCING EMAIL: $email',
      'ANALYZING BREACH PAYLOADS...',
      'FINALIZING REPORT...'
    ];

    int logIndex = 0;
    _scanTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (logIndex < fakeLogs.length) {
          _scanLogs.insert(0, fakeLogs[logIndex]);
          logIndex++;
        } else {
          timer.cancel();
          _finishScan(email);
        }
      });
    });
  }

  void _finishScan(String email) {
    List<Map<String, dynamic>> foundBreaches = [];
    final lowerEmail = email.toLowerCase();

    // Determine breaches based on input to make it feel real
    if (lowerEmail == 'admin@gmail.com' || lowerEmail.contains('test')) {
      foundBreaches = [
        {'name': 'Forum Hacker 2023', 'date': '12 Aug 2023', 'data': ['Passwords', 'IP Addresses', 'Usernames'], 'severity': AppTheme.error},
        {'name': 'Toko Online X Breach', 'date': '05 Mei 2020', 'data': ['Email addresses', 'Passwords', 'Phone numbers'], 'severity': AppTheme.error},
        {'name': 'Sosmed P Breach', 'date': '19 Nov 2019', 'data': ['Email addresses', 'Names'], 'severity': AppTheme.warning},
      ];
    } else if (lowerEmail.length % 2 == 0) {
      foundBreaches = [
        {'name': 'Aplikasi Streaming 2021', 'date': '22 Okt 2021', 'data': ['Email addresses', 'Passwords'], 'severity': AppTheme.warning},
      ];
    }

    setState(() {
      _isScanning = false;
      _hasResult = true;
      _breaches = foundBreaches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DATA LEAK SCANNER')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF100515), AppTheme.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFAB00FF).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.travel_explore, color: Color(0xFFAB00FF), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pindai apakah email kamu pernah bocor di dark web atau insiden peretasan masa lalu.',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.5),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 24),
            
            Text(
              'TARGET EMAIL',
              style: GoogleFonts.orbitron(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            CyberTextField(
              label: 'contoh: admin@gmail.com',
              controller: _emailController,
              prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.textSecondary, size: 20),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 24),
            
            NeonButton(
              label: _isScanning ? 'SCANNING...' : 'SCAN DARK WEB',
              width: double.infinity,
              isLoading: _isScanning,
              onPressed: _isScanning ? () {} : _startScan,
              color: const Color(0xFFAB00FF),
              icon: const Icon(Icons.radar, size: 16, color: Colors.white),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 32),

            if (_isScanning) _buildScanningTerminal(),
            if (_hasResult && !_isScanning) _buildResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningTerminal() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.5)),
        boxShadow: AppTheme.neonGlow(AppTheme.primary, spread: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.terminal, color: AppTheme.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'TERMINAL_OUT',
                style: GoogleFonts.orbitron(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(color: AppTheme.primary),
          Expanded(
            child: ListView.builder(
              itemCount: _scanLogs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '> ${_scanLogs[index]}',
                    style: GoogleFonts.shareTechMono(color: AppTheme.primary, fontSize: 12),
                  ).animate().fadeIn(),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildResult() {
    final isSafe = _breaches.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSafe ? AppTheme.primary.withOpacity(0.1) : AppTheme.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSafe ? AppTheme.primary : AppTheme.error, width: 2),
            boxShadow: AppTheme.neonGlow(isSafe ? AppTheme.primary : AppTheme.error, spread: 1),
          ),
          child: Column(
            children: [
              Icon(
                isSafe ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                color: isSafe ? AppTheme.primary : AppTheme.error,
                size: 64,
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 16),
              Text(
                isSafe ? 'TIDAK DITEMUKAN' : 'DATA BOCOR!',
                style: GoogleFonts.orbitron(
                  color: isSafe ? AppTheme.primary : AppTheme.error,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isSafe 
                  ? 'Kabar baik! Email kamu tidak ditemukan dalam database kebocoran publik saat ini.'
                  : 'Peringatan! Email kamu ditemukan dalam ${_breaches.length} insiden kebocoran data.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.1),

        if (!isSafe) ...[
          const SizedBox(height: 32),
          Text(
            'SUMBER KEBOCORAN',
            style: GoogleFonts.orbitron(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 2),
          ),
          const SizedBox(height: 12),
          ..._breaches.map((breach) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: breach['severity'].withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gpp_bad, color: breach['severity'], size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          breach['name'],
                          style: TextStyle(color: breach['severity'], fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(breach['date'], style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Data Terdampak:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (breach['data'] as List<String>).map((d) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Text(d, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 10)),
                    )).toList(),
                  ),
                ],
              ),
            ).animate().fadeIn().slideX(begin: 0.05),
          )),
          const SizedBox(height: 20),
          Container(
             padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield, color: AppTheme.accent, size: 18),
                  SizedBox(width: 10),
                  Expanded(child: Text('Tindakan disarankan: Segera ubah password untuk akun yang bocor dan aktifkan 2FA (Verifikasi 2 Langkah).', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4))),
                ],
              ),
          ).animate().fadeIn(),
        ],
      ],
    );
  }
}
