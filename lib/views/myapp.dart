import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pharma/providers/history_provider.dart';
import 'package:pharma/providers/history_provider.dart';
import 'package:pharma/providers/home_page_provider.dart';
import 'package:pharma/providers/visit_provider.dart';
import 'package:provider/provider.dart';

import '../configs/app_theme.dart';
import '../controllers/navigation_controller.dart';
import '../providers/admin_user_provider.dart';
import '../providers/app_theme_provider.dart';
import '../providers/connection_provider.dart';
import '../utils/logger_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log().d("MyApp Build Called");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppThemeProvider>(create: (_) => AppThemeProvider(), lazy: false),
        ChangeNotifierProvider<ConnectionProvider>(create: (_) => ConnectionProvider(), lazy: false),
        ChangeNotifierProvider<HomePageProvider>(create: (_) => HomePageProvider(), lazy: false),
        ChangeNotifierProvider<AdminUserProvider>(create: (_) => AdminUserProvider(), lazy: false),
        ChangeNotifierProvider<VisitProvider>(create: (_) => VisitProvider(), lazy: false),
        ChangeNotifierProvider<HistoryProvider>(create: (_) => HistoryProvider(),lazy: false,),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);
  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    Log().d("MainApp Build Called");

    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appThemeProvider, Widget? child) {
        //Log().i("ThemeMode:${appThemeProvider.themeMode}");

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationController.mainScreenNavigator,
          title: "HMS Pharma",
          theme: AppTheme.getThemeFromThemeMode(appThemeProvider.themeMode),
          onGenerateRoute: NavigationController.onMainGeneratedRoutes,
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
          ],
        );
      },
    );
  }
}
