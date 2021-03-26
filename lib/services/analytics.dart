// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/firebase_analytics.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/observer.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  // Singleton setup: prevents multiple instances of this class.
  factory AnalyticsService() => _service;
  AnalyticsService._();
  static final AnalyticsService _service = AnalyticsService._();

  static AnalyticsService get instance => _service;

  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _service._analytics);

  Future<void> logLogin({loginMethod = 'email'}) async {
    return _analytics.logLogin(loginMethod: loginMethod);
  }

  Future<void> setUserProperties({
    required String userId,
    required String userRole,
  }) async {
    await _analytics.setUserId(userId);
    await _analytics.setUserProperty(
      name: 'user_role', // custom userProperty
      value: userRole,
    );
  }

  Future<void> logLogoutPressed({
    bool isBasketEmpty = true,
  }) async {
    return _analytics.logEvent(
      name: 'logout_pressed',
      parameters: {'is_basket_empty': isBasketEmpty},
    );
  }
}
