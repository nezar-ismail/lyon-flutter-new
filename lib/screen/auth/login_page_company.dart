import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/screen/company/other/home_page_company.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api.dart';
import '../../shared/Widgets/button.dart';
import '../../shared/Widgets/text_field_widget.dart';
import '../../shared/Widgets/widget_for_screen.dart';
import '../../shared/styles/colors.dart';

class LogInCompany extends StatefulWidget {
  const LogInCompany({super.key});
  @override
  State<LogInCompany> createState() => _LogInCompanyState();
}
class _LogInCompanyState extends State<LogInCompany> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor1,
          title: const Text('Login As Company'),
        ),
        body: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      logoScreen(context: context),
                      SizedBox(
                        height: _height * .02,
                      ),
                      SizedBox(
                        width: _width * .8,
                        child: textFieldWidgetWithoutFilled(
                            context: context,
                            controller: email,
                            checkEmail: true,
                            textValidatorEmail: "please_enter_correct_email".tr,
                            hintText: "email".tr,
                            textValidatorEmpty: "please_enter_email".tr,
                            type: TextInputType.text,
                            obscureText: false,
                            icons: const Icon(Icons.email)),
                      ),
                      SizedBox(
                        height: _height * .02,
                      ),
                      SizedBox(
                        width: _width * .8,
                        child: textFieldWidgetWithoutFilled(
                          context: context,
                          icons: const Icon(Icons.lock),
                          obscureText: true,
                          type: TextInputType.text,
                          hintText: "password".tr,
                          controller: password,
                          textValidatorEmpty: "please_enter_password".tr,
                          checkLength: true,
                        ),
                      ),
                      SizedBox(
                        height: _height * .05,
                      ),
                      button(
                          context: context,
                          text: 'Login',
                          function: () async {
                            if (_formKey.currentState!.validate()) {
                              String apiUrl = ApiApp.companyLogin;
                              final json = {
                                "email": email.text.toString(),
                                "password": password.text.toString(),
                              };
                              setState(() {
                                isLoading = true;
                              });
                              http.Response response = await http
                                  .post(Uri.parse(apiUrl), body: json)
                                  .whenComplete(() => setState(() {
                                        isLoading = false;
                                      }));
                              bool? isWithRental;
                              bool? isWithfullDay;
                              bool? isWithTrip;
                              var jsonResponse = jsonDecode(response.body);
                              if (jsonResponse['status'] == 200) {
                                SharedPreferences _prefs =
                                    await SharedPreferences.getInstance();
                                _prefs.setString('access_token_company',
                                    jsonResponse['token']);
                                var box = GetStorage();
                                box.write('access', jsonResponse['token']);
                                print(box.read('access'));
                                print(_prefs.getString('access_token_company'));
                                _prefs.setString(
                                    'company_name', jsonResponse['name']);
                                _prefs.setBool('isCompanyLoggedIn', true);
                                if (jsonResponse['rental'] == '1') {
                                  setState(() {
                                    isWithRental = true;
                                  });
                                } else {
                                  setState(() {
                                    isWithRental = false;
                                  });
                                }
                                if (jsonResponse['fullDay'] == '1') {
                                  setState(() {
                                    isWithfullDay = true;
                                  });
                                } else {
                                  setState(() {
                                    isWithfullDay = false;
                                  });
                                }
                                if (jsonResponse['trip'] == '1') {
                                  setState(() {
                                    isWithTrip = true;
                                  });
                                } else {
                                  setState(() {
                                    isWithTrip = false;
                                  });
                                }
                                _prefs.setBool('withRental', isWithRental!);
                                _prefs.setBool('withTrip', isWithTrip!);
                                _prefs.setBool('withFullDay', isWithfullDay!);
                                pushAndRemoveUntil(
                                    context,
                                    HomePageCompany());
                              }
                              showMessage(
                                  context: context,
                                  text: jsonResponse['message']);
                            }
                          })
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}