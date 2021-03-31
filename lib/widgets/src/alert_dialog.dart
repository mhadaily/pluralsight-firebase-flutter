import 'package:flutter/material.dart';
import 'package:wiredbrain/coffee_router.dart';

Future<void> showAlertDialog(String message) async {
  return showDialog<void>(
    context: CoffeeRouter.instance.navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error!'),
        content: Text(message),
      );
    },
  );
}
