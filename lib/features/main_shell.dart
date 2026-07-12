import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';

/// A persistent bottom navigation bar shell wrapping the main tabbed pages.
/// Uses go_router's ShellRoute pattern — each tab is a full Navigator.
class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _tabs = [
    _TabInfo(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', route: '/home'),
    _TabInfo(icon: Icons.build_circle_outlined, activeIcon: Icons.build_circle, label: 'Tools', route: '/tools'),
    _TabInfo(icon: Icons.report_problem_outlined, activeIcon: Icons.report_problem, label: 'Report', route: '/report'),
    _TabInfo(icon: Icons.people_outlined, activeIcon: Icons.people, label: 'Community', route: '/community'),
    _TabInfo(icon: Icons.leaderboard_outlined, activeIcon: Icons.leaderboard, label: 'Profile', route: '/leaderboard'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    // Determine active tab from current route
    int activeIndex = 0;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].route)) {
        activeIndex = i;
        break;
      }
    }
    if (activeIndex != _currentIndex) {
      _currentIndex = activeIndex;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.border, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final t = _tabs[i];
                final isActive = i == _currentIndex;
                return GestureDetector(
                  onTap: () {
                    if (!isActive) {
                      setState(() => _currentIndex = i);
                      context.go(t.route);
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isActive
                          ? AppTheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? t.activeIcon : t.icon,
                          color: isActive ? AppTheme.primary : AppTheme.textSecondary,
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.label,
                          style: TextStyle(
                            color: isActive ? AppTheme.primary : AppTheme.textSecondary,
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
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

class _TabInfo {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  const _TabInfo({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
