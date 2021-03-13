import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wiredbrain/data_providers/http_client.dart';
import 'package:flutter/material.dart';

import 'coffee_router.dart';
import 'data_providers/auth_data_provider.dart';
import 'data_providers/auth_provider.dart';
import './get_theme.dart';
import 'screens/splash_screen.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  // assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter >= 1.17 and Dart >= 2.8
  runZonedGuarded<Future<void>>(() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
  }, (error, stackTrace) async {
    print('Caught Dart Error!');
    if (isInDebugMode) {
      // in development, print error and stack trace
      print('$error');
      print('$stackTrace');
    } else {
      // report to a error tracking system in production
    }
  });

  // You only need to call this method if you need the binding to be initialized before calling runApp.
  WidgetsFlutterBinding.ensureInitialized();
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    final dynamic exception = details.exception;
    final StackTrace? stackTrace = details.stack;
    if (isInDebugMode) {
      print('Caught Framework Error!');
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone
      Zone.current.handleUncaughtError(exception, stackTrace!);
    }
  };
}
