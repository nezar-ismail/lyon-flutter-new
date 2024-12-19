// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
// import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/screen/auth/updated_create_new_password.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/Widgets/widget_for_screen.dart';
import 'package:lyon/shared/mehod/otp_verification.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class VerifyOtpWhenUserForgotPassword extends StatefulWidget {
  VerifyOtpWhenUserForgotPassword({
    super.key,
    required this.enteredEmail,
  });

  final String enteredEmail;
  bool isDisabled = false;
  int? time;

  @override
  State<VerifyOtpWhenUserForgotPassword> createState() =>
      _VerifyOtpWhenUserForgotPasswordState();
}
class _VerifyOtpWhenUserForgotPasswordState
    extends State<VerifyOtpWhenUserForgotPassword> {
  TextEditingController textEditingController = TextEditingController();
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
                          child: CircularProgressIndicator(),
                        );
                      });
                  var response = await OtpVerification().verifyOTP(
                      widget.enteredEmail, textEditingController.text);
                  if (response) {
                    Navigator.of(context).pop();
                    push(
                      context,
                      UpdatedCreateNewPassword(
                        enteredEmail: widget.enteredEmail,
                      ),
                    );
                    showMessage(
                        context: context, text: 'Code verified successfully');
                  } else {
                    Navigator.of(context).pop();
                    showMessage(context: context, text: 'Invalid code');
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
                  var response =
                      await OtpVerification().sendOTP(widget.enteredEmail, 1);
                  if (response) {
                    //Now, I am supposed to navigate the user to the Reset password screen.
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
