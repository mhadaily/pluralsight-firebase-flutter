import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wiredbrain/const.dart';

class ShopsScreen extends StatelessWidget {
  const ShopsScreen();
  static String routeName = 'Shops';
  static Route<ShopsScreen> route() {
    return MaterialPageRoute<ShopsScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => ShopsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: darkBrown,
        size: 70.0,
      ),
    );
  }
}
