class AppConstants {
  // App Info
  static const String appName = 'CyberLaw';
  static const String appVersion = '2.0.0';

  // ── Routes ──
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';

  // Shell (tab) routes
  static const String routeHome = '/home';
  static const String routeLearn = '/learn';
  static const String routeToolkit = '/toolkit';
  static const String routeCommunity = '/community';
  static const String routeProfile = '/profile';

  // Sub-routes
  static const String routePathDetail = '/learn/path';
  static const String routeLesson = '/learn/lesson';
  static const String routeCtfArena = '/learn/ctf';
  static const String routeChallenge = '/learn/ctf/challenge';
  static const String routeToolDetail = '/toolkit/tool';
  static const String routeSkillTree = '/profile/skill-tree';
  static const String routeSettings = '/profile/settings';
  static const String routeLeaderboard = '/community/leaderboard';

  // ── Hive boxes (keep for backwards compatibility) ──
  static const String hiveBoxUsers = 'cyberlaw_users';
  static const String hiveBoxSession = 'cyberlaw_session';
  static const String hiveBoxReports = 'cyberlaw_reports';
  static const String hiveBoxOnboarding = 'cyberlaw_onboarding';

  static const String sessionEmailKey = 'logged_in_email';

  // ── Old routes (kept for compatibility) ──
  static const String routePasswordChecker = '/tools/password';
  static const String routeBase64Tool = '/tools/base64';
  static const String routeHashGenerator = '/tools/hash';
  static const String routePhishingChecker = '/tools/phishing';
  static const String routeBinaryDecoder = '/tools/binary';
  static const String routeDataLeak = '/tools/data-leak';
}
