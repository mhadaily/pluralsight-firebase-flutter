import 'package:firebase_auth/firebase_auth.dart';
import 'package:wiredbrain/coffee_router.dart';
import 'package:wiredbrain/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiredbrain/services/analytics.dart';
import 'package:wiredbrain/services/auth.dart';
import 'package:wiredbrain/widgets/button.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen();

  static String routeName = 'Logout';

  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final AnalyticsService _analyticsService = AnalyticsService.instance;
  final AuthService _authService = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _authService.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          String? email;
          if (snapshot.hasData) {
            final User? user = snapshot.data;
            email = user?.email ?? 'Not Set';
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/coffee_break.svg",
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      semanticsLabel: 'Wired Brain Coffee',
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text('Email: $email'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CommonButton(
                  onPressed: () {
                    _analyticsService.logLogoutPressed();
                    _authService.signOut();
                    CoffeeRouter.instance
                        .pushAndRemoveUntil(HomeScreen.route());
                  },
                  text: 'Logout',
                ),
              ),
            ],
          );
        });
  }
}
