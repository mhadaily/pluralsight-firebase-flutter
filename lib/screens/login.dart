import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiredbrain/coffee_router.dart';
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
  final AnalyticsService _analyticsService = AnalyticsService.instance;
  final AuthService _authService = AuthService.instance;

  StreamSubscription<User?>? _authChangeSubscription;
  bool _loading = false;

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
        CoffeeRouter.instance.pushAndRemoveUntil(MenuScreen.route());
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
                  if (Platform.isIOS)
                    FutureBuilder<bool>(
                      future: _authService.isAppleSignInAvailable(),
                      builder: (context, AsyncSnapshot<bool> snapshot) {
                        final bool isAvailable = snapshot.data ?? false;
                        if (isAvailable) {
                          return SignInButton.apple(onPressed: () {
                            _authService.signInWithApple();
                          });
                        }
                        return SizedBox();
                      },
                    ),
                  if (Platform.isIOS) SizedBox(height: 20),
                  SignInButton.mail(onPressed: () {
                    CoffeeRouter.instance.push(LoginEmailScreen.route());
                  }),
                  SizedBox(height: 20),
                  Center(child: Text('OR')),
                  SizedBox(height: 20),
                  CommonButton(
                    onPressed: _loading
                        ? null // disable button
                        : () async {
                            setState(() {
                              _loading = true;
                            });

                            await _authService.signInAnonymously();

                            setState(() {
                              _loading = false;
                            });
                          },
                    text: _loading
                        ? 'Please wait, Login...'
                        : 'Continue anonymously',
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
                CoffeeRouter.instance.pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                final String phoneNumber = _textFieldController.text;
                if (_textFieldController.text.isNotEmpty) {
                  _authService.signInWithPhoneNumber(phoneNumber);
                }
                CoffeeRouter.instance.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
