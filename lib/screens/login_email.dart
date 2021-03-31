import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiredbrain/coffee_router.dart';
import 'package:wiredbrain/constants.dart';
import 'package:wiredbrain/enums/enums.dart';
import 'package:wiredbrain/screens/forgot_password.dart';
import 'package:wiredbrain/screens/menu.dart';
import 'package:wiredbrain/services/services.dart';
import 'package:wiredbrain/widgets/widgets.dart';

class LoginEmailScreen extends StatefulWidget {
  static String routeName = 'loginEmailScreen';
  static Route<LoginEmailScreen> route() {
    return MaterialPageRoute<LoginEmailScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => LoginEmailScreen(),
    );
  }

  @override
  _LoginEmailScreenState createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  final AnalyticsService _analyticsService = AnalyticsService.instance;
  final AuthService _authService = AuthService.instance;

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                LoginInputs(
                  emailFieldController: _emailFieldController,
                  passwordFieldController: _passwordFieldController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        CoffeeRouter.instance.push(
                          ForgotPasswordScreen.route(),
                        );
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: darkBrown,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                CommonButton(
                  onPressed: _onSubmitLoginButton,
                  text: 'login',
                ),
                CreateAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isFormValidated() {
    final FormState form = formKey.currentState!;
    return form.validate();
  }

  _onSubmitLoginButton() async {
    if (_isFormValidated()) {
      ScaffoldMessenger.of(context).showSnackBar(
        loadingSnackBar(
          text: " Signing-In...",
        ),
      );

      final User? user = await _authService.signInWithEmailAndPassword(
        email: _emailFieldController.text,
        password: _passwordFieldController.text,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (user != null) {
        _analyticsService.logLogin();

        _analyticsService.setUserProperties(
          userId: user.uid,
          userRoles: [UserRole.customer],
        );

        CoffeeRouter.instance.push(MenuScreen.route());
      }
    }
  }
}
