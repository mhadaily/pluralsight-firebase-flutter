import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiredbrain/screens/menu.dart';
import 'package:wiredbrain/services/analytics.dart';
import 'package:wiredbrain/services/auth.dart';
import 'package:wiredbrain/widgets/button.dart';
import 'package:wiredbrain/widgets/social_button.dart';

import 'login_email.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  static String routeName = 'loginScreen';
  static Route<LoginScreen> route() {
    return MaterialPageRoute<LoginScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => const LoginScreen(),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _textFieldController = TextEditingController();

  final AnalyticsService _analyticsService = AnalyticsService();
  final AuthService _authService = AuthService();

  StreamSubscription<User?>? _authChangeSubscription;

  @override
  void initState() {
    super.initState();
    _authChangeSubscription = _authService.authStateChanges().listen((user) {
      if (user != null) {
        // which provider users is logged
        user.providerData.forEach((provider) {
          _analyticsService.logLogin(loginMethod: provider.providerId);
        });

        _analyticsService.setUserProperties(
          userId: user.uid,
          userRole: 'customer',
        );

        Navigator.of(context).pushAndRemoveUntil(
          MenuScreen.route(),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _authChangeSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Login"),
        actions: [
          Image.asset(
            "assets/logo.png",
            semanticLabel: 'logo',
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: SvgPicture.asset(
                "assets/hotbeverage.svg",
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                semanticsLabel: 'Wired Brain Coffee',
                fit: BoxFit.fitWidth,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SignInButton.phone(onPressed: () {
                  //   _displayTextInputDialog(context);
                  // }),
                  // SizedBox(height: 20),
                  SignInButton.google(onPressed: () {
                    _authService.signInWithGoogle();
                  }),
                  SizedBox(height: 20),
                  SignInButton.apple(onPressed: () {
                    _authService.signInWithApple();
                  }),
                  SizedBox(height: 20),
                  SignInButton.mail(onPressed: () {
                    Navigator.of(context).push(
                      LoginEmailScreen.route(),
                    );
                  }),
                  SizedBox(height: 20),
                  Center(child: Text('OR')),
                  SizedBox(height: 20),
                  CommonButton(
                    onPressed: () {
                      _authService.signInAnonymously();
                    },
                    text: 'Continue anonymously',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Phone Number'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Phone number"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                final String phoneNumber = _textFieldController.text;
                if (_textFieldController.text.isNotEmpty) {
                  _authService.signInWithPhoneNumber(phoneNumber);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
