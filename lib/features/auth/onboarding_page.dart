import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

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
      subtitle: 'Your personal cybersecurity academy. Learn, practice, and master the art of ethical hacking.',
    ),
    _OnboardData(
      icon: Icons.menu_book,
      color: AppColors.secondary,
      title: 'Structured\nLearning Paths',
      subtitle: 'Follow curated paths from beginner to advanced. Network security, cryptography, web security, and more.',
    ),
    _OnboardData(
      icon: Icons.flag_outlined,
      color: AppColors.warning,
      title: 'CTF Challenges\n& Cyber Tools',
      subtitle: 'Test your skills with Capture The Flag challenges and use our toolkit for real-world practice.',
    ),
    _OnboardData(
      icon: Icons.forum,
      color: AppColors.success,
      title: 'Join the\nCommunity',
      subtitle: 'Connect with fellow cybersecurity enthusiasts. Share knowledge, find teams, and grow together.',
    ),
  ];

  Future<void> _next() async {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Save onboarding completion
      final box = await Hive.openBox(AppConstants.hiveBoxOnboarding);
      await box.put('onboarding_completed', true);
      if (mounted) {
        context.go('/login');
      }
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              AppColors.bgPrimary,
              AppColors.bgSecondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () async {
                    final box = await Hive.openBox(AppConstants.hiveBoxOnboarding);
                    await box.put('onboarding_completed', true);
                    if (context.mounted) context.go('/login');
                  },
                  child: Text(
                    'Skip',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.section,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon container
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  p.color.withOpacity(0.15),
                                  p.color.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: p.color.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              p.icon,
                              color: p.color,
                              size: 56,
                            ),
                          ).animate().scale(
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                              ),

                          const SizedBox(height: AppSpacing.section),

                          Text(
                            p.title,
                            textAlign: TextAlign.center,
                            style: AppTypography.h2.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ).animate().fadeIn(
                                delay: 200.ms,
                                duration: 400.ms,
                              ),

                          const SizedBox(height: AppSpacing.lg),

                          Text(
                            p.subtitle,
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ).animate().fadeIn(
                                delay: 300.ms,
                                duration: 400.ms,
                              ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Dots + next button
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.section,
                  0,
                  AppSpacing.section,
                  AppSpacing.section,
                ),
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
                            color: isActive
                                ? _pages[i].color
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: _pages[i].color.withOpacity(0.4),
                                      blurRadius: 8,
                                    )
                                  ]
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _pages[_currentPage].color,
                              _pages[_currentPage].color.withOpacity(0.8),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          boxShadow: [
                            BoxShadow(
                              color: _pages[_currentPage].color
                                  .withOpacity(0.3),
                              blurRadius: 16,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1
                                  ? 'GET STARTED'
                                  : 'NEXT',
                              style: AppTypography.button.copyWith(
                                color: AppColors.textInverse,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Icon(
                              _currentPage == _pages.length - 1
                                  ? Icons.arrow_forward
                                  : Icons.arrow_forward,
                              color: AppColors.textInverse,
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

class _OnboardData {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _OnboardData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}
