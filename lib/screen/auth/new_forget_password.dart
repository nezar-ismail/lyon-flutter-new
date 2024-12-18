import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lyon/screen/auth/verify_otp_when_user_forgot_password.dart';
import 'package:lyon/shared/Widgets/appbar.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/Widgets/widget_for_screen.dart';
import 'package:lyon/shared/mehod/otp_verification.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';

class NewForgetPassword extends StatefulWidget {
  const NewForgetPassword({super.key});
  @override
  State<NewForgetPassword> createState() => _NewForgetPasswordState();
}
class _NewForgetPasswordState extends State<NewForgetPassword> {
  TextEditingController emailTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBars(
          canBack: true,
          withIcon: false,
          text: 'forget_password'.tr,
          context: context),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: _height * .1,
                    ),
                    Center(child: logoScreen(context: context)),
                    SizedBox(
                      height: _height * .05,
                    ),
                    textFieldWidgetWithoutFilled(
                        context: context,
                        controller: emailTextEditingController,
                        checkEmail: true,
                        textValidatorEmail: "please_enter_correct_email".tr,
                        hintText: "email".tr,
                        textValidatorEmpty: "please_enter_email".tr,
                        type: TextInputType.text,
                        obscureText: false,
                        icons: const Icon(Icons.email)),
                    SizedBox(
                      height: _height * .05,
                    ),
                    button(
                        context: context,
                        text: "Send Verification code",
                        function: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeCap: StrokeCap.square,
                                    strokeWidth: 5,
                                  ),
                                );
                              });
                          var response = await OtpVerification()
                              .sendOTP(emailTextEditingController.text, 1);
                          if (response) {
                            Navigator.of(context).pop();
                            pushAndRemoveUntil(
                                context,
                                VerifyOtpWhenUserForgotPassword(
                                  enteredEmail: emailTextEditingController.text,
                                ));
                            showMessage(
                                context: context,
                                text:
                                    'A code has been sent to your email. Please check your email');
                          } else {
                            Navigator.of(context).pop();
                            showMessage(
                                context: context,
                                text: "Invalid email (email not found)");
                          }
                        })
                  ]))),
    );
  }
}
