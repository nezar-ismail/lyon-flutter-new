import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lyon/other/main_screen.dart';
import 'package:lyon/screen/auth/login/cubit/login_cubit.dart';
import 'package:lyon/screen/auth/login/widgets/language_toggle.dart';
import 'package:lyon/screen/auth/login/widgets/login_button.dart';
import 'package:lyon/screen/auth/login/widgets/role_navigate_button.dart';
import 'package:lyon/screen/auth/login_page_company.dart';
import 'package:lyon/screen/auth/new_forget_password.dart';
import 'package:lyon/screen/auth/signup/sigup_page.dart';
import 'package:lyon/shared/Widgets/widget_for_screen.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:lyon/v_done/utils/custom_snackbar.dart';

// ignore: must_be_immutable
class LogInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  PhoneNumber initialPhoneNumber = PhoneNumber(isoCode: 'JO');

  LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset:
              true, // Ensure resizing when keyboard appears
          body: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginLoading) {
                showDialog(
                  context: context,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is LoginSuccess) {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainScreen(numberIndex: 0, isGuest: false),
                  ),
                );
              } else if (state is LoginError) {
                Navigator.of(context).pop();
                  customSnackBar(context, state.errorMessage, "Oops");
              } else if (state is LanguageChanged) {}
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  logoScreen(context: context),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InternationalPhoneNumberInput(
                            autoFocus: true,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            onInputChanged: (value) {
                              initialPhoneNumber= value;
                            },
                            textFieldController: phoneController,
                            initialValue: initialPhoneNumber,
                            inputDecoration: InputDecoration(
                              hintText: "enter_your_phone_number".tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        // Password Input
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText:  "password".tr,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        // Forgot Password Button
                        TextButton(
                          onPressed: () {
                              push(context, const NewForgetPassword());
                          },
                          child: Text("forget_password".tr,),
                        ),
                        // Login Button
                        LoginButton(
                          formKey: _formKey,
                          initialPhoneNumber: initialPhoneNumber,
                          phoneController: phoneController,
                          passwordController: passwordController,
                        ),
                        // Register Button
                        RoleNavigatButton(color: Colors.white,text: "signup".tr, onPressed: () {
                          logInfo("Register button pressed");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                        }),
                        // Guest Mode Button
                        RoleNavigatButton(color: Colors.yellow,text: "guest".tr, onPressed: () {
                          logInfo("Guest button pressed");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(numberIndex: 0, isGuest: true)));
                        }),
                        // Company Mode Button
                        RoleNavigatButton(
                          color: Colors.white,
                            text: "company".tr, onPressed: () {
                              logInfo("Company button pressed");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInCompany()));
                            }),
                        // Language Switch Button (EN/AR)
                        const LanguageToggle(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
