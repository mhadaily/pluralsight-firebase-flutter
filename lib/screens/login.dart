import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailFieldController.text = 'me@majidhajian.com';
    _passwordFieldController.text = 'me@majidhajian.com';
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
                  SignInButton.google(onPressed: () {}),
                  SizedBox(height: 20),
                  SignInButton.apple(onPressed: () {}),
                  SizedBox(height: 20),
                  SignInButton.twitter(onPressed: () {}),
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
                    onPressed: () {},
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
}
