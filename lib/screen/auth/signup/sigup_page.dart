import 'package:flutter/material.dart';
import 'package:lyon/screen/auth/signup/signup_user.dart';
import 'package:lyon/shared/Widgets/widget_for_screen.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(child: logoScreen(context: context)),
            const SignupUser(),
          ],
        ),
      )),
    );
  }
}
