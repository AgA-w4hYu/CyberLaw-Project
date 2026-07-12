import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class CyberLabPage extends StatelessWidget {
  const CyberLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _LabCategory(icon: Icons.key, label: 'Cryptography', desc: '2 Challenges', color: AppTheme.primary, category: 'crypto', difficulty: 'Easy–Medium'),
      _LabCategory(icon: Icons.manage_search, label: 'Forensics', desc: '1 Challenge', color: AppTheme.secondary, category: 'forensic', difficulty: 'Medium'),
      _LabCategory(icon: Icons.language, label: 'Web Security', desc: '1 Challenge', color: AppTheme.warning, category: 'web', difficulty: 'Easy'),
      _LabCategory(icon: Icons.memory, label: 'Reverse Engineering', desc: '1 Challenge', color: AppTheme.accent, category: 'reverse', difficulty: 'Easy'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('CYBER LAB')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A0F2E), AppTheme.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFAB00FF).withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFAB00FF).withOpacity(0.15),
                    boxShadow: AppTheme.neonGlow(const Color(0xFFAB00FF), spread: 1),
                  ),
                  child: const Icon(Icons.science, color: Color(0xFFAB00FF), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ethical Hacking Lab', style: GoogleFonts.orbitron(color: const Color(0xFFAB00FF), fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('Praktikkan keahlian cybersecurity melalui tantangan CTF yang realistis', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 24),

          Text('KATEGORI TANTANGAN', style: GoogleFonts.orbitron(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 3)),
          const SizedBox(height: 14),

          ...categories.asMap().entries.map((e) {
            final i = e.key;
            final cat = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => context.push('${AppConstants.routeCtfHome}?category=${cat.category}'),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cat.color.withOpacity(0.1), AppTheme.surface],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cat.color.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cat.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(cat.icon, color: cat.color, size: 26),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cat.label, style: GoogleFonts.rajdhani(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                const Icon(Icons.flag, color: AppTheme.textSecondary, size: 13),
                                const SizedBox(width: 4),
                                Text(cat.desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                const SizedBox(width: 12),
                                const Icon(Icons.speed, color: AppTheme.textSecondary, size: 13),
                                const SizedBox(width: 4),
                                Text(cat.difficulty, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: cat.color),
                    ],
                  ),
                )
                    .animate(delay: Duration(milliseconds: 100 + i * 80))
                    .fadeIn()
                    .slideX(begin: 0.1, duration: 350.ms),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LabCategory {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;
  final String category;
  final String difficulty;
  const _LabCategory({required this.icon, required this.label, required this.desc, required this.color, required this.category, required this.difficulty});
}
