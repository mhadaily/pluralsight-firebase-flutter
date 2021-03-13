import 'package:flutter/material.dart';
import 'coffee_router.dart';
import 'data_providers/auth_data_provider.dart';
import 'data_providers/auth_provider.dart';
import 'data_providers/http_client.dart';
import './get_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    AuthProvider(
      auth: AuthDataProvider(http: HttpClient()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        navigatorKey: CoffeeRouter.instance.navigatorKey,
        theme: getTheme(),
      ),
    ),
  );
}
