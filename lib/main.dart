import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'models/user_adapter.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  // Open boxes
  await Hive.openBox(AppConstants.hiveBoxUsers);
  await Hive.openBox(AppConstants.hiveBoxSession);
  await Hive.openBox(AppConstants.hiveBoxReports);
  await Hive.openBox(AppConstants.hiveBoxOnboarding);

  // Create auth provider and restore session
  final authProvider = AuthProvider();
  await authProvider.restoreSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: const CyberLawGuardianApp(),
    ),
  );
}

class CyberLawGuardianApp extends StatelessWidget {
  const CyberLawGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CyberLaw Guardian',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
