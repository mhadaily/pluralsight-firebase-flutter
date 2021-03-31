import 'package:flutter/foundation.dart';

enum Activity {
  login,
  addToCart,
  placeOrder,
  logout,
}

extension ActivityExtension on Activity {
  String get name {
    return describeEnum(this);
  }
}
