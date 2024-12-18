import 'package:flutter/material.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/api/method_api.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/Widgets/widget_for_screen.dart';
import 'package:lyon/shared/styles/colors.dart';

import 'login/login_page.dart';

class CreateNewPassword extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const CreateNewPassword(
      {super.key, required this.countryCode, required this.phoneNumber});

  @override
  _CreateNewPasswordState createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                logoScreen(context: context),
                const SizedBox(
                  height: 30,
                ),
                textFieldWidgetWithoutFilled(
                  context: context,
                  controller: password,
                  textValidatorEmpty: "Please Enter Password",
                  hintText: "Password",
                  icons: const Icon(Icons.lock),
                  type: TextInputType.text,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                textFieldWidgetWithoutFilled(
                  context: context,
                  controller: confirmPassword,
                  textValidatorEmpty: "Please Enter Confirm Password",
                  hintText: "Confirm Password",
                  icons: const Icon(Icons.lock),
                  type: TextInputType.text,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                button(
                    context: context,
                    text: "Create New Password",
                    function: () {
                      if (_formKey.currentState!.validate()) {
                        if (password.text == confirmPassword.text) {
                          MethodAppApi()
                              .methodPOST(url: ApiApp.createNewPassword, body: {
                            "phone": widget.phoneNumber,
                            "countryCode": widget.countryCode,
                            "newPassword": password.text.toString()
                          }).then((value) =>
                                  {pushAndRemoveUntil(context, LogInScreen())});
                          showMessage(
                              text: "Password changed successfully",
                              context: context);
                        } else {
                          showMessage(
                              text: "Password Not Confirmed", context: context);
                        }
                      }
                      //Create New Password
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
