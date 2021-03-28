import 'package:firebase_auth/firebase_auth.dart';
import 'package:wiredbrain/coffee_router.dart';
import 'package:wiredbrain/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiredbrain/services/analytics.dart';
import 'package:wiredbrain/services/auth.dart';
import 'package:wiredbrain/widgets/button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();

  static String routeName = 'profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AnalyticsService _analyticsService = AnalyticsService.instance;
  final AuthService _authService = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error!')));
        }
        final User? user = snapshot.data;
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
            if (user != null && user.isAnonymous)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text('You are logged in annonymously!'),
              ),
            if (user != null && !user.isAnonymous)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text('Email: ${user.email}'),
              ),
            if (user != null && !user.emailVerified && !user.isAnonymous)
              CommonButton(
                text: 'Verify Your Email',
                onPressed: () {
                  user.sendEmailVerification();
                },
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CommonButton(
                onPressed: () async {
                  await _analyticsService.logLogoutPressed();
                  await _authService.signOut();
                  CoffeeRouter.instance.pushAndRemoveUntil(HomeScreen.route());
                },
                text: 'Logout',
              ),
            ),
          ],
        );
      },
    );
  }
}
