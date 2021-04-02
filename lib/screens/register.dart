import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wiredbrain/coffee_router.dart';
import 'package:wiredbrain/enums/enums.dart';
import 'package:wiredbrain/screens/menu.dart';
import 'package:wiredbrain/services/services.dart';
import 'package:wiredbrain/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  static String routeName = 'RegisterScreen';
  static Route<RegisterScreen> route() {
    return MaterialPageRoute<RegisterScreen>(
      settings: RouteSettings(name: routeName),
      builder: (BuildContext context) => RegisterScreen(),
    );
  }

  final formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  final AnalyticsService _analyticsService = AnalyticsService.instance;
  final AuthService _authService = AuthService.instance;
  final FirestoreService _firestoreService = FirestoreService.instance;

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
                  onPressed: () {
                    _onSubmitLoginButton(context);
                  },
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

  _onSubmitLoginButton(context) async {
    if (_isFormValidated()) {
      ScaffoldMessenger.of(context).showSnackBar(
        loadingSnackBar(
          text: " Creating user...",
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
          userRoles: [UserRole.customer],
        );

        await _firestoreService.setUserRoles(user.uid, [UserRole.customer]);

        CoffeeRouter.instance.pushAndRemoveUntil(MenuScreen.route());
      }
    }
  }
}
