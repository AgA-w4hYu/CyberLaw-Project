import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../features/auth/login_page.dart';
import '../../features/auth/onboarding_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/community/community_page.dart';
import '../../features/community/leaderboard_page.dart';
import '../../features/home/home_page.dart';
import '../../features/learn/learn_page.dart';
import '../../features/main_shell.dart';
import '../../features/profile/profile_page.dart';
import '../../features/profile/settings_page.dart';
import '../../features/profile/skill_tree_page.dart';
import '../../features/toolkit/toolkit_page.dart';
import '../../providers/auth_provider.dart';
import '../constants/app_constants.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppConstants.routeOnboarding,
  redirect: (BuildContext context, GoRouterState state) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLoggedIn = authProvider.isLoggedIn;
    final path = state.matchedLocation;

    final isAuthRoute =
        path == AppConstants.routeLogin || path == AppConstants.routeRegister;
    final isOnboarding = path == AppConstants.routeOnboarding;

    // Check if onboarding was already completed
    final onboardingBox = await Hive.openBox(AppConstants.hiveBoxOnboarding);
    final onboardingCompleted =
        onboardingBox.get('onboarding_completed', defaultValue: false) as bool;

    // If onboarding completed and user is not logged in, skip to login
    if (onboardingCompleted && !isLoggedIn && !isAuthRoute) {
      return AppConstants.routeLogin;
    }

    // If onboarding completed and user is on onboarding, skip to login
    if (onboardingCompleted && isOnboarding && !isLoggedIn) {
      return AppConstants.routeLogin;
    }

    // If not logged in, not on auth or onboarding routes, redirect to login
    if (!isLoggedIn && !isAuthRoute && !isOnboarding) {
      return AppConstants.routeLogin;
    }

    // If logged in and on auth or onboarding routes, redirect to home
    if (isLoggedIn && (isAuthRoute || isOnboarding)) {
      return AppConstants.routeHome;
    }

    return null;
  },
  routes: [
    // ── Auth routes (outside shell) ──
    GoRoute(
      path: AppConstants.routeOnboarding,
      builder: (_, __) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppConstants.routeLogin,
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: AppConstants.routeRegister,
      builder: (_, __) => const RegisterPage(),
    ),

    // ── ShellRoute with bottom nav ──
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppConstants.routeHome,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: AppConstants.routeLearn,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LearnPage(),
          ),
        ),
        GoRoute(
          path: AppConstants.routeToolkit,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ToolkitPage(),
          ),
        ),
        GoRoute(
          path: AppConstants.routeCommunity,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CommunityPage(),
          ),
        ),
        GoRoute(
          path: AppConstants.routeProfile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfilePage(),
          ),
        ),
      ],
    ),

    // ── Full-screen routes (outside shell) ──
    GoRoute(
      path: AppConstants.routeLeaderboard,
      builder: (_, __) => const LeaderboardPage(),
    ),
    GoRoute(
      path: AppConstants.routeSettings,
      builder: (_, __) => const SettingsPage(),
    ),
    GoRoute(
      path: AppConstants.routeSkillTree,
      builder: (_, __) => const SkillTreePage(),
    ),
  ],
);
