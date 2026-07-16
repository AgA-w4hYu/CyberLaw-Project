import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardData(
      icon: Icons.shield_outlined,
      color: AppColors.primary,
      title: 'Welcome to\nCyberLaw',
      subtitle: 'Your personal cybersecurity academy. Learn, practice, and master ethical hacking.',
    ),
    _OnboardData(
      icon: Icons.menu_book,
      color: AppColors.secondary,
      title: 'Structured\nLearning Paths',
      subtitle: 'Network security, cryptography, web security, forensics — follow curated paths from beginner to advanced.',
    ),
    _OnboardData(
      icon: Icons.build_outlined,
      color: AppColors.warning,
      title: 'Cyber Tools\n& CTF Challenges',
      subtitle: '30+ interactive security tools. Real Capture The Flag challenges. Test your skills.',
    ),
  ];

  void _next() async {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _showAuthOptions();
    }
  }

  void _showAuthOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.shield_outlined, color: AppColors.primary, size: 48),
            const SizedBox(height: 16),
            Text(
              'Start Your Journey',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Create an account to save progress or explore as a guest.',
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/register');
                },
                child: const Text('CREATE ACCOUNT'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/login');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: const Text('LOG IN'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity, height: 48,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<AuthProvider>().enterGuestMode();
                  context.go('/home');
                },
                child: Text(
                  'Continue as Guest',
                  style: AppTypography.body.copyWith(color: AppColors.textTertiary),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), AppColors.bgPrimary, AppColors.bgSecondary],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    context.read<AuthProvider>().enterGuestMode();
                    context.go('/home');
                  },
                  child: Text('Skip', style: AppTypography.body.copyWith(color: AppColors.textTertiary)),
                ).animate().fadeIn(delay: 200.ms),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageCtrl,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) {
                    final p = _pages[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.section),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120, height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [p.color.withOpacity(0.15), p.color.withOpacity(0.05)],
                              ),
                              border: Border.all(color: p.color.withOpacity(0.3), width: 1),
                            ),
                            alignment: Alignment.center,
                            child: Icon(p.icon, color: p.color, size: 56),
                          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: 32),
                          Text(
                            p.title,
                            textAlign: TextAlign.center,
                            style: AppTypography.h2.copyWith(color: AppColors.textPrimary, height: 1.3),
                          ).animate().fadeIn(delay: 200.ms),
                          const SizedBox(height: 16),
                          Text(
                            p.subtitle,
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(color: AppColors.textSecondary, height: 1.6),
                          ).animate().fadeIn(delay: 300.ms),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                child: Row(
                  children: [
                    Row(
                      children: List.generate(_pages.length, (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          width: isActive ? 28 : 8, height: 8,
                          decoration: BoxDecoration(
                            color: isActive ? _pages[i].color : AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: isActive ? [BoxShadow(color: _pages[i].color.withOpacity(0.4), blurRadius: 8)] : null,
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _next,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_pages[_currentPage].color, _pages[_currentPage].color.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: _pages[_currentPage].color.withOpacity(0.3), blurRadius: 16, spreadRadius: 1)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT',
                              style: AppTypography.button.copyWith(color: AppColors.textInverse, letterSpacing: 1),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: AppColors.textInverse, size: 18),
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

class _OnboardData {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _OnboardData({required this.icon, required this.color, required this.title, required this.subtitle});
}
