import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/home/home_page.dart';
import '../../features/cyber_law/cyber_law_page.dart';
import '../../features/cyber_law/law_article_detail_page.dart';
import '../../features/security_awareness/security_insights_page.dart';
import '../../features/security_tools/tools_page.dart';
import '../../features/security_tools/password_checker.dart';
import '../../features/security_tools/base64_tool.dart';
import '../../features/security_tools/hash_generator.dart';
import '../../features/security_tools/phishing_checker.dart';
import '../../features/security_tools/binary_decoder.dart';
import '../../features/security_tools/data_leak_scanner.dart';
import '../../features/ctf/cyber_lab_page.dart';
import '../../features/ctf/ctf_home.dart';
import '../../features/ctf/crypto_challenge.dart';
import '../../features/ctf/forensic_challenge.dart';
import '../../features/ctf/web_challenge.dart';
import '../../features/ctf/reverse_challenge.dart';
import '../../features/report/report_page.dart';
import '../../features/community/community_page.dart';
import '../../features/leaderboard/leaderboard_page.dart';
import '../../providers/auth_provider.dart';
import '../../models/ctf_challenge_model.dart';
import '../constants/app_constants.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppConstants.routeLogin,
  redirect: (BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLoggedIn = authProvider.isLoggedIn;
    final isAuthRoute = state.matchedLocation == AppConstants.routeLogin ||
        state.matchedLocation == AppConstants.routeRegister;

    if (!isLoggedIn && !isAuthRoute) return AppConstants.routeLogin;
    if (isLoggedIn && isAuthRoute) return AppConstants.routeHome;
    return null;
  },
  routes: [
    GoRoute(
      path: AppConstants.routeLogin,
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: AppConstants.routeRegister,
      builder: (_, __) => const RegisterPage(),
    ),
    GoRoute(
      path: AppConstants.routeHome,
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: AppConstants.routeCyberLaw,
      builder: (_, __) => const CyberLawPage(),
      routes: [
        GoRoute(
          path: 'article',
          builder: (_, state) {
            final articleId = state.uri.queryParameters['id'] ?? '';
            return LawArticleDetailPage(articleId: articleId);
          },
        ),
      ],
    ),
    GoRoute(
      path: AppConstants.routeInsights,
      builder: (_, state) {
        final q = state.uri.queryParameters['q'];
        return SecurityInsightsPage(initialQuery: q);
      },
    ),
    GoRoute(
      path: AppConstants.routeTools,
      builder: (_, __) => const ToolsPage(),
      routes: [
        GoRoute(path: 'password', builder: (_, __) => const PasswordCheckerPage()),
        GoRoute(path: 'base64', builder: (_, __) => const Base64ToolPage()),
        GoRoute(path: 'hash', builder: (_, __) => const HashGeneratorPage()),
        GoRoute(path: 'phishing', builder: (_, __) => const PhishingCheckerPage()),
        GoRoute(path: 'binary', builder: (_, __) => const BinaryDecoderPage()),
        GoRoute(path: 'data-leak', builder: (_, __) => const DataLeakScannerPage()),
      ],
    ),
    GoRoute(
      path: AppConstants.routeCyberLab,
      builder: (_, __) => const CyberLabPage(),
    ),
    GoRoute(
      path: AppConstants.routeCtfHome,
      builder: (_, state) {
        final category = state.uri.queryParameters['category'] ?? 'crypto';
        return CtfHome(category: category);
      },
    ),
    GoRoute(path: AppConstants.routeCryptoChallenge, builder: (_, state) => CryptoChallenege(challenge: state.extra as CtfChallengeModel?)),
    GoRoute(path: AppConstants.routeForensicChallenge, builder: (_, state) => ForensicChallenge(challenge: state.extra as CtfChallengeModel?)),
    GoRoute(path: AppConstants.routeWebChallenge, builder: (_, state) => WebChallenge(challenge: state.extra as CtfChallengeModel?)),
    GoRoute(path: AppConstants.routeReverseChallenge, builder: (_, state) => ReverseChallenge(challenge: state.extra as CtfChallengeModel?)),
    GoRoute(path: AppConstants.routeReport, builder: (_, __) => const ReportPage()),
    GoRoute(path: AppConstants.routeCommunity, builder: (_, __) => const CommunityPage()),
    GoRoute(path: AppConstants.routeLeaderboard, builder: (_, __) => const LeaderboardPage()),
  ],
);
