import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiredbrain/services/analytics.dart';
import 'package:wiredbrain/services/auth.dart';
import 'package:wiredbrain/widgets/loading_snack_bar.dart';
import '../widgets/button.dart';
import '../widgets/login_inputs.dart';
import '../coffee_router.dart';
import 'menu.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = 'RegisterScreen';
  static Route<RegisterScreen> route() {
    return MaterialPageRoute<RegisterScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => RegisterScreen(),
    );
  }

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  final AnalyticsService _analyticsService = AnalyticsService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                LoginInputs(
                  emailFieldController: _emailFieldController,
                  passwordFieldController: _passwordFieldController,
                ),
                CommonButton(
                  onPressed: _onSubmitLoginButton,
                  text: 'Register',
                ),
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

      final User? user = await _authService.createUserWithEmailAndPassword(
        email: _emailFieldController.text,
        password: _passwordFieldController.text,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (user != null) {
        _analyticsService.logLogin();

        _analyticsService.setUserProperties(
          userId: user.uid,
          userRole: 'customer',
        );

        CoffeeRouter.instance.push(MenuScreen.route());
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Registration went wrong! User already in use! try again!',
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
