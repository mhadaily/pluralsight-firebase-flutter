import 'package:flutter/material.dart';
import 'package:wiredbrain/coffee_router.dart';
import 'package:wiredbrain/constants.dart';
import 'package:wiredbrain/screens/register.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don\'t have an account?",
          style: TextStyle(color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: () {
            CoffeeRouter.instance.push(RegisterScreen.route());
          },
          child: Text(
            " Register",
            style: TextStyle(
              color: darkBrown,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
