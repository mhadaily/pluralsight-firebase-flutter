import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:wiredbrain/services/analytics.dart';

import 'coffee_router.dart';
import './get_theme.dart';
import 'screens/splash_screen.dart';

class CoffeeApp extends StatelessWidget {
  final FirebaseAnalyticsObserver observer = AnalyticsService.observer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      navigatorKey: CoffeeRouter.instance.navigatorKey,
      navigatorObservers: <NavigatorObserver>[observer],
      theme: getTheme(),
    );
  }
}
