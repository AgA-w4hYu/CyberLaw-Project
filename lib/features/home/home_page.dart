import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/security_insight_model.dart';
import '../../providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollCtrl,
        slivers: [
          // ── Hero section with parallax ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: AppTheme.surface,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final expandRatio = ((constraints.maxHeight - kToolbarHeight) / (180 - kToolbarHeight)).clamp(0.0, 1.0);
                return FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background parallax layer — moves slower
                      Transform.translate(
                        offset: Offset(0, -expandRatio * 30),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF0D2137), AppTheme.surface],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      // Decorative grid lines (parallax background)
                      Transform.translate(
                        offset: Offset(0, -expandRatio * 20),
                        child: Opacity(
                          opacity: 0.08 * expandRatio,
                          child: CustomPaint(
                            painter: _GridPainter(),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                      // Foreground content — moves at normal speed
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [AppTheme.primary, AppTheme.secondary],
                                ),
                                boxShadow: AppTheme.neonGlow(AppTheme.primary, spread: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                user?.avatarInitials ?? '??',
                                style: GoogleFonts.orbitron(
                                  color: AppTheme.background,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Selamat Datang,', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                  Text(
                                    user?.name ?? 'Hacker',
                                    style: GoogleFonts.orbitron(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: AppTheme.warning, size: 14),
                                      const SizedBox(width: 4),
                                      Text('${user?.score ?? 0} pts', style: const TextStyle(color: AppTheme.warning, fontSize: 12)),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.leaderboard, color: AppTheme.secondary, size: 14),
                                      const SizedBox(width: 4),
                                      Text('Rank #${user?.rank ?? 0}', style: const TextStyle(color: AppTheme.secondary, fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout, color: AppTheme.textSecondary),
                              onPressed: () {
                                context.read<AuthProvider>().logout();
                                context.go(AppConstants.routeLogin);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  collapseMode: CollapseMode.parallax,
                );
              },
            ),
          ),

          // ── Content ──
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ThreatBanner().animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 24),

                Text('MENU UTAMA', style: GoogleFonts.orbitron(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 3)),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.1,
                  children: [
                    _FeatureCard(icon: Icons.gavel, label: 'Cyber Law', subtitle: '4 Artikel', color: AppTheme.primary, onTap: () => context.push(AppConstants.routeCyberLaw), index: 0),
                    _FeatureCard(icon: Icons.build_circle, label: 'Security Tools', subtitle: '6 Tools', color: AppTheme.secondary, onTap: () => context.push(AppConstants.routeTools), index: 1),
                    _FeatureCard(icon: Icons.science, label: 'Cyber Lab', subtitle: 'CTF Challenges', color: const Color(0xFFAB00FF), onTap: () => context.push(AppConstants.routeCyberLab), index: 2),
                    _FeatureCard(icon: Icons.report_problem, label: 'Laporkan', subtitle: 'Kejahatan Siber', color: AppTheme.accent, onTap: () => context.push(AppConstants.routeReport), index: 3),
                    _FeatureCard(icon: Icons.people, label: 'Komunitas', subtitle: 'White-Hat Hub', color: AppTheme.warning, onTap: () => context.push(AppConstants.routeCommunity), index: 4),
                    _FeatureCard(icon: Icons.leaderboard, label: 'Leaderboard', subtitle: 'Top Hackers', color: const Color(0xFF00B4D8), onTap: () => context.push(AppConstants.routeLeaderboard), index: 5),
                  ],
                ),
                const SizedBox(height: 24),
                _InsightPreviewSection(),
                const SizedBox(height: 24),
                _ThreatFeedSection(),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grid painter for background parallax effect ──
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Threat Banner ──
class _ThreatBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF102028)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary.withOpacity(0.1),
              boxShadow: AppTheme.neonGlow(AppTheme.primary, spread: 1),
            ),
            child: const Icon(Icons.radar, color: AppTheme.primary, size: 22)
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: 3.seconds),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('THREAT LEVEL: LOW', style: TextStyle(color: AppTheme.secondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 4),
                const Text('Tidak ada ancaman aktif terdeteksi. Sistem aman.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Feature Card with depth effect ──
class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final int index;

  const _FeatureCard({required this.icon, required this.label, required this.subtitle, required this.color, required this.onTap, required this.index});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_pressed ? 0.95 : 1.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color.withOpacity(_pressed ? 0.2 : 0.12), AppTheme.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _pressed ? widget.color : widget.color.withOpacity(0.3),
            width: _pressed ? 1.5 : 1,
          ),
          boxShadow: _pressed ? AppTheme.neonGlow(widget.color, spread: 2) : [
            BoxShadow(color: widget.color.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.color, size: 26),
            ),
            const Spacer(),
            Text(widget.label, style: GoogleFonts.rajdhani(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(widget.subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: 150 + widget.index * 80))
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOut),
    );
  }
}

// ── Threat Feed ──
class _ThreatFeedSection extends StatelessWidget {
  final List<Map<String, dynamic>> _feeds = const [
    {'icon': Icons.warning_amber, 'color': Color(0xFFFFD60A), 'title': 'Phishing Campaign Baru', 'desc': 'Serangan phishing menargetkan pengguna bank di Indonesia', 'time': '2 jam lalu'},
    {'icon': Icons.bug_report, 'color': Color(0xFFFF453A), 'title': 'CVE-2024-3094 XZ Utils', 'desc': 'Kerentanan kritis ditemukan pada library kompresi Linux', 'time': '5 jam lalu'},
    {'icon': Icons.shield, 'color': Color(0xFF00FF9C), 'title': 'Update Keamanan', 'desc': 'BSSN merilis panduan keamanan siber terbaru untuk UMKM', 'time': '1 hari lalu'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('THREAT FEED', style: GoogleFonts.orbitron(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 3)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.accent, width: 0.5),
              ),
              child: GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua threat feed akan segera hadir!'))),
                child: const Text('PILIHAN', style: TextStyle(color: AppTheme.accent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_feeds.length, (i) {
          final feed = _feeds[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Icon(feed['icon'] as IconData, color: feed['color'] as Color, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(feed['title'] as String, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(feed['desc'] as String, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(feed['time'] as String, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                ],
              ),
            ).animate(delay: Duration(milliseconds: 200 + i * 100)).fadeIn().slideX(begin: 0.1),
          );
        }),
      ],
    );
  }
}

// ── Insight Preview ──
class _InsightPreviewSection extends StatelessWidget {
  final List<SecurityInsightModel> _previewInsights = SecurityInsightData.insights.take(3).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('PANDUAN DARURAT', style: GoogleFonts.orbitron(color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 3)),
            const Spacer(),
            GestureDetector(
              onTap: () => context.push(AppConstants.routeInsights),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: const Row(children: [
                  Text('Lihat semua', style: TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_outward, color: AppTheme.primary, size: 14),
                ]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text('Buat user yang panik karena akun diretas, HP hilang, atau kena phishing.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.45)),
        const SizedBox(height: 12),
        ..._previewInsights.asMap().entries.map((entry) {
          final insight = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => context.push('${AppConstants.routeInsights}?q=${Uri.encodeComponent(insight.title)}'),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: insight.color.withOpacity(0.25)),
                  boxShadow: [
                    BoxShadow(color: insight.color.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: insight.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(insight.icon, color: insight.color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(insight.title, style: GoogleFonts.rajdhani(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 3),
                          Text(insight.summary, maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.35)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                  ],
                ),
              ),
            ).animate(delay: Duration(milliseconds: 100 + entry.key * 90)).fadeIn(),
          );
        }),
      ],
    );
  }
}
