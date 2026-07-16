import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', route: '/home'),
    _TabItem(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Learn', route: '/learn'),
    _TabItem(icon: Icons.build_outlined, activeIcon: Icons.build, label: 'Toolkit', route: '/toolkit'),
    _TabItem(icon: Icons.forum_outlined, activeIcon: Icons.forum, label: 'Community', route: '/community'),
    _TabItem(icon: Icons.report_outlined, activeIcon: Icons.report, label: 'Report', route: '/report'),
    _TabItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', route: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    int currentIndex = 0;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].route)) { currentIndex = i; break; }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          border: Border(top: BorderSide(color: AppColors.borderSoft, width: 0.5)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final isActive = i == currentIndex;
                return GestureDetector(
                  onTap: () { if (!isActive) context.go(tab.route); },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primaryBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? tab.activeIcon : tab.icon,
                          color: isActive ? AppColors.primary : AppColors.textTertiary,
                          size: 22,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          tab.label,
                          style: AppTypography.overline.copyWith(
                            color: isActive ? AppColors.primary : AppColors.textTertiary,
                            fontSize: 9,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon, activeIcon;
  final String label, route;
  const _TabItem({required this.icon, required this.activeIcon, required this.label, required this.route});
}
