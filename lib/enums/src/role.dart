import 'package:flutter/foundation.dart';

enum UserRole {
  customer,
  admin,
  unknown,
}

extension UserRoleExtension on UserRole {
  String get name {
    return describeEnum(this);
  }
}
