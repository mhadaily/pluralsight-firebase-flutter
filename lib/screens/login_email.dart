import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wiredbrain/data_providers/http_client.dart';
import 'package:wiredbrain/services/analytics.dart';
import '../widgets/button.dart';
import '../widgets/create_account.dart';
import '../widgets/login_inputs.dart';
import '../data_providers/auth_data_provider.dart';
import '../coffee_router.dart';
import '../constants.dart';
import 'menu.dart';

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

  final AnalyticsService _analyticsService = AnalyticsService();

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
                  Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: darkBrown,
                      fontWeight: FontWeight.w500,
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
    );
  }

  bool _isFormValidated() {
    final FormState form = formKey.currentState!;
    return form.validate();
  }

  _onSubmitLoginButton() async {
    if (_isFormValidated()) {
      ScaffoldMessenger.of(context).showSnackBar(_loadingSnackBar());
      final BaseAuth auth = AuthDataProvider(http: HttpClient());

      final String email = _emailFieldController.text;
      final String password = _passwordFieldController.text;
      final bool loggedIn = await auth.signInWithEmailAndPassword(
        email,
        password,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (loggedIn) {
        _analyticsService.logLogin();

        _analyticsService.setUserProperties(
          userId: email,
          userRole: 'customer',
        );

        CoffeeRouter.instance.push(MenuScreen.route());
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Your username / password is incorrect'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  SnackBar _loadingSnackBar() {
    return SnackBar(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            width: 20,
          ),
          Text(" Signing-In...")
        ],
      ),
    );
  }
}
