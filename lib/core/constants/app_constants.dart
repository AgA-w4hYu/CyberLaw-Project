class AppConstants {
  static const String appName = 'CyberLaw';
  static const String appVersion = '2.0.0';

  // Auth routes
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';

  // Shell (tab) routes
  static const String routeHome = '/home';
  static const String routeLearn = '/learn';
  static const String routeToolkit = '/toolkit';
  static const String routeCommunity = '/community';
  static const String routeReport = '/report';
  static const String routeProfile = '/profile';

  // Full-screen routes
  static const String routePathDetail = '/learn/path';
  static const String routeLesson = '/learn/lesson';
  static const String routeCtfArena = '/learn/ctf';
  static const String routeChallenge = '/learn/ctf/challenge';
  static const String routeToolDetail = '/toolkit/tool';
  static const String routeSkillTree = '/profile/skill-tree';
  static const String routeSettings = '/profile/settings';
  static const String routeLeaderboard = '/community/leaderboard';

  // Hive boxes
  static const String hiveBoxUsers = 'cyberlaw_users';
  static const String hiveBoxSession = 'cyberlaw_session';
  static const String hiveBoxReports = 'cyberlaw_reports';
  static const String hiveBoxOnboarding = 'cyberlaw_onboarding';

  static const String sessionEmailKey = 'logged_in_email';
}
