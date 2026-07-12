import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      _ToolEntry(
        icon: Icons.password,
        label: 'Password Checker',
        desc: 'Analisis kekuatan password',
        color: AppTheme.secondary,
        route: AppConstants.routePasswordChecker,
      ),
      _ToolEntry(
        icon: Icons.code,
        label: 'Base64 Tool',
        desc: 'Encode & decode Base64',
        color: AppTheme.primary,
        route: AppConstants.routeBase64Tool,
      ),
      _ToolEntry(
        icon: Icons.fingerprint,
        label: 'Hash Generator',
        desc: 'MD5, SHA1, SHA256',
        color: const Color(0xFFAB00FF),
        route: AppConstants.routeHashGenerator,
      ),
      _ToolEntry(
        icon: Icons.link_off,
        label: 'Phishing Checker',
        desc: 'Cek URL mencurigakan',
        color: AppTheme.accent,
        route: AppConstants.routePhishingChecker,
      ),
      _ToolEntry(
        icon: Icons.memory,
        label: 'Binary Decoder',
        desc: 'Binary → ASCII text',
        color: AppTheme.warning,
        route: AppConstants.routeBinaryDecoder,
      ),
      _ToolEntry(
        icon: Icons.password,
        label: 'Common Password Checker',
        desc: 'Cek password dari daftar umum yang bocor',
        color: const Color(0xFF00B4D8),
        route: AppConstants.routeDataLeak,
        disclaimer: 'Alat ini memeriksa password secara lokal di perangkat Anda.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('SECURITY TOOLS')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D1A0F), AppTheme.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.secondary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.build_circle, color: AppTheme.secondary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Alat keamanan siber untuk analisis dan pengujian — hanya untuk tujuan edukatif.',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 24),
          ...tools.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ToolTile(tool: e.value, index: e.key),
          )),
        ],
      ),
    );
  }
}

class _ToolEntry {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;
  final String route;
  final String? disclaimer;
  const _ToolEntry({required this.icon, required this.label, required this.desc, required this.color, required this.route, this.disclaimer});
}

class _ToolTile extends StatelessWidget {
  final _ToolEntry tool;
  final int index;
  const _ToolTile({required this.tool, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(tool.route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tool.color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tool.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(tool.icon, color: tool.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool.label, style: GoogleFonts.rajdhani(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(tool.desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: tool.color),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: 100 + index * 70))
          .fadeIn()
          .slideX(begin: 0.1, duration: 350.ms, curve: Curves.easeOut),
    );
  }
}
