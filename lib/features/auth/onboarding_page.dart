import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingData(
      icon: Icons.shield_outlined,
      color: AppTheme.primary,
      title: 'Selamat Datang di\nCyberLaw Guardian',
      body: 'Platform belajar keamanan siber yang dirancang untuk membantu Anda memahami dan menghadapi ancaman digital.',
    ),
    _OnboardingData(
      icon: Icons.build_circle_outlined,
      color: AppTheme.secondary,
      title: 'Alat Keamanan\nEdukatif',
      body: 'Gunakan tool seperti Password Checker, Phishing Checker, dan Hash Generator untuk belajar melindungi diri Anda secara offline di perangkat ini.',
    ),
    _OnboardingData(
      icon: Icons.science_outlined,
      color: const Color(0xFFAB00FF),
      title: 'CTF Challenge\n& Komunitas',
      body: 'Uji keahlian Anda dengan tantangan Capture The Flag dan bergabung dengan komunitas white-hat Indonesia.',
    ),
    _OnboardingData(
      icon: Icons.gavel_outlined,
      color: AppTheme.accent,
      title: 'Hukum Siber\nIndonesia',
      body: 'Pahami UU ITE, UU PDP, dan batasan legal aktivitas keamanan siber di Indonesia.',
    ),
  ];

  Future<void> _complete() async {
    final box = await Hive.openBox(AppConstants.hiveBoxOnboarding);
    await box.put('onboarding_completed', true);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF0D2137), AppTheme.background],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _complete,
                  child: const Text(
                    'Lewati',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageCtrl,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) {
                    final p = _pages[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: p.color.withOpacity(0.12),
                              border: Border.all(color: p.color.withOpacity(0.4)),
                              boxShadow: AppTheme.neonGlow(p.color, spread: 2),
                            ),
                            child: Icon(p.icon, color: p.color, size: 48),
                          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: 40),
                          Text(
                            p.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.orbitron(
                              color: AppTheme.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              height: 1.3,
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(height: 16),
                          Text(
                            p.body,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ).animate().fadeIn(delay: 300.ms),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Dots + next button
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                child: Row(
                  children: [
                    // Page indicators
                    Row(
                      children: List.generate(_pages.length, (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          width: isActive ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive ? _pages[i].color : AppTheme.border,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: isActive
                                ? [BoxShadow(color: _pages[i].color.withOpacity(0.4), blurRadius: 8)]
                                : null,
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    // Next / Done button
                    GestureDetector(
                      onTap: _next,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        decoration: BoxDecoration(
                          color: _pages[_currentPage].color,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppTheme.neonGlow(_pages[_currentPage].color, spread: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1 ? 'MULAI' : 'LANJUT',
                              style: GoogleFonts.orbitron(
                                color: AppTheme.background,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentPage == _pages.length - 1
                                  ? Icons.check_circle_outline
                                  : Icons.arrow_forward,
                              color: AppTheme.background,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  const _OnboardingData({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });
}
