import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/api/method_api.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/Widgets/widget_for_screen.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../other/main_screen.dart';
import 'create_new_password.dart';

class VerifyCode extends StatefulWidget {
  final bool createNewPassword;
  final String verificationId;
  final Map body;
  final String? phone;
  final String? countryCode;
  final String? token;
  const VerifyCode(
      {super.key, required this.verificationId,
      this.token,
      this.phone,
      this.countryCode,
      required this.createNewPassword,
      required this.body});
  @override
  // ignore: library_private_types_in_public_api
  _VerifyCodeState createState() => _VerifyCodeState();
}
class _VerifyCodeState extends State<VerifyCode> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController newTextEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>.broadcast();
    super.initState();
  }
  @override
  void dispose() {
    errorController!.close();
    newTextEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  String currentText = "";
  bool completed = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Center(child: logoScreen(context: context)),
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    'check_your_email'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      autoDisposeControllers: false,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        inactiveFillColor: backgroundColor,
                        inactiveColor: Colors.black,
                        activeColor: backgroundColor,
                        activeFillColor: backgroundColor,
                        selectedColor: backgroundColor,
                        selectedFillColor: backgroundColor,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 40,
                        fieldWidth: 40,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                        setState(() {
                          completed = true;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  button(
                      context: context,
                      text: "Verify Code",
                      function: () async {
                        if (completed == true) {
                          setState(() {
                            isLoading = true;
                          });
                          PhoneAuthProvider.credential(
                                  verificationId:
                                      widget.verificationId.toString(),
                                  smsCode: currentText);
                          if (widget.createNewPassword != true) {
                            await MethodAppApi()
                                .methodPOSTSignUp(
                                    url: ApiApp.signUp, body: widget.body)
                                .whenComplete(() {
                              setState(() {
                                isLoading = false;
                              });
                            });

                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "access_token", widget.token!);
                            push(
                                // ignore: use_build_context_synchronously
                                context,
                                MainScreen(
                                  numberIndex: 0,
                                ));
                          } else if (widget.createNewPassword == true) {
                            pushAndRemoveUntil(
                                context,
                                CreateNewPassword(
                                    phoneNumber: widget.phone.toString(),
                                    countryCode:
                                        widget.countryCode.toString()));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("a valid in code"),
                            ));
                          }
                        }
                      }),
                ],
              ),
            ),
    );
  }
}
