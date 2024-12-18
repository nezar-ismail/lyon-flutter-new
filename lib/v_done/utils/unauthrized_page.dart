import 'package:flutter/material.dart';
import 'package:lyon/screen/auth/login/login_page.dart';
import 'package:lyon/screen/auth/signup/signup_user.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';

class LoginPageRequierd extends StatelessWidget {
  const LoginPageRequierd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('You must login to access this page'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You must login to access this page',
              style: TextStyle(fontSize: 22),
            ),
            const Icon(
              Icons.login_outlined,
              size: 200,
            ),
            button(
              context: context,
              function: () {
                push(context, LogInScreen());
              },
              text: 'Login',
            ),
            const SizedBox(
              height: 30,
            ),
            button(
              context: context,
              function: () {
                push(context, const SignupUser());
              },
              text: 'Create an account',
            )
          ],
        ),
      ),
    );
  }
}
