// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/api/method_api.dart';
import 'package:lyon/other/main_screen.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/Widgets/widget_for_screen.dart';
import 'package:lyon/shared/mehod/otp_verification.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewVerifyOTP extends StatefulWidget {
  NewVerifyOTP({
    super.key,
    required this.email,
    required this.theBodyOfSignUpAPI,
    this.token,
  });
  final String email;
  final Map theBodyOfSignUpAPI;
  String? token;
  bool isDisabled = false;
  int time = 60;
  @override
  State<NewVerifyOTP> createState() => _NewVerifyOTPState();
}
class _NewVerifyOTPState extends State<NewVerifyOTP> {
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>.broadcast();
    super.initState();
  }
  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                child: Pinput(
                  length: 6,
                  showCursor: true,
                  controller: textEditingController,
                )),
            const SizedBox(
              height: 40,
            ),
            button(
                context: context,
                text: "Verify Code",
                function: () async {
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
                  bool response = await OtpVerification()
                      .verifyOTP(widget.email, textEditingController.text);
                  if (response) {
                    //now I am supposed to sign the user up
                    Navigator.of(context).pop();
                    await MethodAppApi().methodPOSTSignUp(
                        url: ApiApp.signUp, body: widget.theBodyOfSignUpAPI);
                    logInfo("Signed up to DB successfully");
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setString("access_token", widget.token!);
                    sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.setBool("isFaceIdEnabled", true);
                    var box = GetStorage();
                    box.write("isFaceIdEnabled", true);
                    push(context, MainScreen(numberIndex: 0));
                    showMessage(
                        context: context, text: 'Signed up successfully.');
                  } else {
                    var box = GetStorage();
                    box.write("isFaceIdEnabled", false);
                    Navigator.of(context).pop();
                    showMessage(context: context, text: "Verification failed");
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            Text(
              'did_not_receive_code'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () async {
                  if (widget.isDisabled) {
                    return;
                  }
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      });

                  var response = await OtpVerification().sendOTP(widget.email, 0);

                  if (response) {
                    Navigator.of(context).pop();

                    showMessage(
                        context: context, text: 'Code sent successfully');
                  } else {
                    Navigator.of(context).pop();

                    showMessage(context: context, text: 'Failed to send code');
                  }
                  setState(() {
                    widget.isDisabled = true;
                  });
                  Timer(const Duration(seconds: 60), () {
                    setState(() {
                      widget.isDisabled = false;
                      widget.time--;
                    });
                  });
                },
                child: Text("resend_code".tr,
                    style: TextStyle(
                      color: widget.isDisabled ? Colors.grey : secondaryColor1,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ))),
          ])),
    );
  }
}
