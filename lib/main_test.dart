import 'package:flutter/material.dart';
import 'coffee_router.dart';
import './get_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      navigatorKey: CoffeeRouter.instance.navigatorKey,
      theme: getTheme(),
    ),
  );
}
