// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/api/method_api.dart';
import 'package:lyon/other/main_screen.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/Widgets/widget_for_screen.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdatedCreateNewPassword extends StatefulWidget {
  const UpdatedCreateNewPassword({super.key, required this.enteredEmail});

  final String enteredEmail;

  @override
  State<UpdatedCreateNewPassword> createState() =>
      _UpdatedCreateNewPasswordState();
}

class _UpdatedCreateNewPasswordState extends State<UpdatedCreateNewPassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  const SizedBox(
                    height: 70,
                  ),
                  logoScreen(context: context),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          textFieldWidgetWithoutFilled(
                            context: context,
                            controller: newPasswordController,
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
                            controller: confirmPasswordController,
                            textValidatorEmpty: "Please Enter Confirm Password",
                            hintText: "Confirm Password",
                            icons: const Icon(Icons.lock),
                            type: TextInputType.text,
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      )),
                  button(
                    context: context,
                    text: "Submit new password",
                    function: () async {
                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        showMessage(
                            context: context, text: "Password does not match");
                        return false;
                      }
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeCap: StrokeCap.square,
                                  strokeWidth: 5,
                                ),
                              );
                            });
                        try {
                          var response = await http.post(
                              Uri.parse(
                                  'https://lyon-jo.com/api/resetPaswword.php'),
                              body: {
                                'email': widget.enteredEmail,
                                'newPassword': newPasswordController.text
                              });
                          var jsonResponse = jsonDecode(response.body);
                          if (jsonResponse['status'] == 200) {
                            try {
                              var response2 = await http.post(
                                  Uri.parse(
                                      'https://lyon-jo.com/api/getPhoneByEmail.php'),
                                  body: {
                                    'email': widget.enteredEmail,
                                  });
                              var jsonResponse2 = jsonDecode(response2.body);
                              String? token =
                                  await FirebaseMessaging.instance.getToken();
                              MethodAppApi()
                                  .methodPOSTLogIn(url: ApiApp.logIn, body: {
                                "countryCode":
                                    jsonResponse2["countryCode"].toString(),
                                "input": jsonResponse2["phone"].toString(),
                                "password":
                                    newPasswordController.text.toString(),
                                "mobile": "1",
                                "token": token,
                              }).then((value) async {
                                if (value == 200) {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setBool(
                                      "isFaceIdEnabled", true);
                                  var box = GetStorage();
                                  box.write("isFaceIdEnabled", true);
                                  pushAndRemoveUntil(
                                      context,
                                      MainScreen(
                                        numberIndex: 0,
                                      ));
                                  showMessage(
                                      context: context,
                                      text: 'Signed in successfully.');
                                } else if (value == 102) {
                                  showMessage(
                                      context: context,
                                      text: 'Phone does not exist!');
                                } else if (value == 101) {
                                  showMessage(
                                      context: context,
                                      text: 'Incorrect password!');
                                } else {
                                  showMessage(
                                      context: context,
                                      text:
                                          'Somthing Wrong! Please Contact Us');
                                }
                              });
                            } catch (e) {
                              Navigator.of(context).pop();
                              showMessage(
                                  context: context,
                                  text: 'Error occured, please try again');
                            }
                            Navigator.of(context).pop();
                            showMessage(
                                context: context,
                                text: 'Password changed successfully');
                            return true;
                          } else {
                            Navigator.of(context).pop();
                            return false;
                          }
                        } catch (e) {
                          Navigator.of(context).pop();
                          return false;
                        }
                      }
                    },
                  )
                ]))));
  }
}
