import 'dart:convert';
import 'dart:developer';
import 'package:country_ip/country_ip.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/model/error_model.dart';
import 'package:lyon/screen/auth/login/login_page.dart';
import 'package:lyon/screen/auth/new_verify_otp.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/mehod/otp_verification.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../v_done/utils/Translate/localization.dart';

// ignore: unused_element
// File? _image;

class SignupUser extends StatefulWidget {
  const SignupUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupUserState createState() => _SignupUserState();
}

class _SignupUserState extends State<SignupUser> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController date = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late PhoneNumber theRealPhone;
  final TextEditingController phoneController = TextEditingController();
  bool checkNumber = false;
  bool checkLengthNumber = false;
  DateTime now = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String years = DateTime((DateTime.now().year) - 18).toString();
  String avatar = "";
  String? _chosenValue;
  bool isCurrencyNull = false;
  String selectedCountryCode = 'JO';

  Future<String?> getUserCountryCode() async {
    final countryIpResponse = await CountryIp.find();
    setState(() {
      selectedCountryCode = countryIpResponse?.countryCode.toString() ?? '';
    });
    return countryIpResponse?.countryCode.toString() ?? '';
  }

  @override
  initState() {
    getUserCountryCode();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (DateTime((DateTime.now().year) - 28, 1)),
        firstDate: DateTime((DateTime.now().year) - 130),
        lastDate: DateTime((DateTime.now().year) - 28, 12),
        errorInvalidText: "Out of range");
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date.text =
            "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool openCircle = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: openCircle
          ? const CircularProgressIndicator(
              backgroundColor: secondaryColor1,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: width / 3,
                        // height: _height * .1,
                        child: textFieldWidgetWithoutFilledSmall(
                          context: context,
                          obscureText: false,
                          textValidatorEmpty: "please_enter_first_name".tr,
                          type: TextInputType.text,
                          hintText: "first_name".tr,
                          controller: firstName,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: width / 3,
                        // height: _height * .1,
                        child: textFieldWidgetWithoutFilledSmall(
                          context: context,
                          textValidatorEmpty: "please_enter_last_name".tr,
                          obscureText: false,
                          type: TextInputType.text,
                          hintText: "last_name".tr,
                          controller: lastName,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * .02,
                ),
                Container(
                  width: width,
                  decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (value) async {
                      theRealPhone = value;

                      selectedCountryCode = value.isoCode ?? 'JO';
                      if (value.phoneNumber!.isNotEmpty) {
                        setState(() {
                          checkNumber = false;
                          checkLengthNumber = false;
                        });
                      }
                      if (value.phoneNumber!.length < 9) {
                        setState(() {
                          checkNumber = false;
                          checkLengthNumber = false;
                        });
                      } else {
                        setState(() {
                          checkNumber = true;
                        });
                      }
                    },
                    selectorTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    initialValue: PhoneNumber(isoCode: selectedCountryCode),
                    textFieldController: phoneController,
                    inputBorder: InputBorder.none,
                    inputDecoration: InputDecoration(
                      hintText: "enter_your_phone_number".tr,
                      border: InputBorder.none,
                    ),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                      useEmoji: true,
                    ),
                    // maxLength: 10,
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        setState(() {
                          checkNumber = false;
                          checkLengthNumber = false;
                        });
                      }
                      if (val.length < 9) {
                        setState(() {
                          checkNumber = false;
                          checkLengthNumber = false;
                        });
                      }
                      setState(() {
                        checkNumber = true;
                      });

                      return null;
                    },
                  ),
                ),
                checkLengthNumber
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: width * .01,
                            top: width * .02,
                            left: width * .04,
                            right: width * .04),
                        child: CustomText(
                          text: 'phone_number_not_valid'.tr,
                          color: Colors.red.shade700,
                          alignment: LocalizationService().getCurrentLang() ==
                                  "English"
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          size: 12,
                        ),
                      )
                    : const Text(""),
                textFieldWidgetWithoutFilled(
                    context: context,
                    controller: email,
                    checkEmail: true,
                    textValidatorEmail: "please_enter_correct_email".tr,
                    hintText: "email".tr,
                    textValidatorEmpty: "please_enter_email".tr,
                    type: TextInputType.text,
                    obscureText: false,
                    icons: const Icon(Icons.email)),
                SizedBox(
                  height: height * .02,
                ),
                textFieldWidgetWithoutFilled(
                  context: context,
                  icons: const Icon(Icons.lock),
                  obscureText: true,
                  type: TextInputType.text,
                  hintText: "password".tr,
                  controller: password,
                  textValidatorEmpty: "please_enter_password".tr,
                  checkLength: true,
                ),
                SizedBox(
                  height: height * .02,
                ),
                textFieldWidgetWithoutFilled(
                    context: context,
                    icons: const Icon(Icons.lock),
                    obscureText: true,
                    type: TextInputType.text,
                    hintText: "confirm_password".tr,
                    controller: confirmPassword,
                    checkLength: true,
                    textValidatorEmpty: "please_enter_confirm_password".tr),
                SizedBox(
                  height: height * .02,
                ),
                textFieldWidgetWithoutFilledWithFunction(
                  context: context,
                  controller: date,
                  icons: const Icon(Icons.calendar_today),
                  hintText: "birthdate".tr,
                  fun: () => _selectDate(context),
                  textValidatorEmpty: "please_enter_birthdate".tr,
                ),
                SizedBox(
                  height: height * .02,
                ),
                DropdownButtonFormField<String>(
                  focusColor: Colors.transparent,
                  value: _chosenValue,
                  validator: (value) =>
                      value == null ? "please_choose_currency".tr : null,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  elevation: 2,
                  iconEnabledColor: Colors.black45,
                  isExpanded: true,
                  items: <String>[
                    'JOD',
                    'USD',
                    'EUR',
                    'AED',
                    'GBP',
                    'SAR',
                    'KWD',
                    'BHD',
                    'OMR',
                    'QAR',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    "please_choose_currency".tr,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                ),
                SizedBox(
                  height: height * .02,
                ),
                button(
                  context: context,
                  text: "signup".tr,
                  function: () async {
                    try {
                      String? token =
                          await FirebaseMessaging.instance.getToken();
                      logInfo("FCM Token: $token");

                      Map<String, String> bodySignUp = {
                        "firstName": firstName.text.toString(),
                        "lastName": lastName.text.toString(),
                        "countryCode": theRealPhone.dialCode.toString(),
                        "phone": phoneController.text.toString(),
                        "email": email.text.toString(),
                        "password": password.text.toString(),
                        "birthdate": date.text.toString(),
                        "token": token.toString(),
                        "currency": _chosenValue.toString(),
                        "mobile": "1"
                      };


                      if (phoneController.text.length < 9) {
                        showMessage(
                            // ignore: use_build_context_synchronously
                            context: context,
                            text: "phone_number_not_valid".tr);
                        return;
                      }

                      if (phoneController.text.length < 9) {
                        setState(() {
                          checkNumber = true;
                        });
                      }

                      if (_formKey.currentState!.validate()) {
                        Get.dialog(
                          AlertDialog(
                            title: Text("number_check".tr),
                            content: SizedBox(
                              width: 20,
                              height: 20,
                              child: Text(
                                "${theRealPhone.dialCode.toString().removeAllWhitespace}${phoneController.text.removeAllWhitespace}",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  return;
                                },
                                child: Text("back_button".tr),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Ensure widget is still mounted before calling setState
                                  if (mounted) {
                                    Get.back();
                                    setState(() {
                                      openCircle = true;
                                      isCurrencyNull = false;
                                    });
                                  }

                                  var name = firstName.text + lastName.text;
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setString("name", name);
                                  sharedPreferences.setString(
                                      "email", email.text);
                                  sharedPreferences.setString("address", "");
                                  sharedPreferences.setString("street", "");

                                  var url = ApiApp.checkDuplicates;
                                  var response = await http.post(
                                    Uri.parse(url),
                                    headers: {
                                      "Content-Type":
                                          "application/x-www-form-urlencoded"
                                    },
                                    body: {
                                      "countryCode":
                                          theRealPhone.dialCode.toString(),
                                      "phone": phoneController.text.toString(),
                                      "email": email.text.toString()
                                    },
                                  );

                                  var responseBody = jsonDecode(response.body);
                                  var isDuplicates =
                                      ErrorCheck.fromJson(responseBody);

                                  if (isDuplicates.status == 200) {
                                    logInfo("isDuplicates ${isDuplicates.error}");
                                    var response = await OtpVerification()
                                        .sendOTP(email.text, 0);
                                    if (response) {
                                      pushAndRemoveUntil(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        NewVerifyOTP(
                                          email: email.text,
                                          theBodyOfSignUpAPI: bodySignUp,
                                          token: token.toString(),
                                        ),
                                      );
                                    }
                                  } else {
                                    logError("isDuplicates ${isDuplicates.error}");
                                    if (mounted) {
                                      showMessage(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          text: isDuplicates.error.toString());
                                      setState(() {
                                        openCircle = false;
                                        isCurrencyNull = false;
                                      });
                                    }
                                  }
                                },
                                child: Text("confirm_button".tr),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      log("Error getting token: $e");
                    }
                  },
                ),
                const Divider(
                  color: Color(0xFF0066b3),
                  thickness: 0.20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "already have an account?",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 86, 85, 85)),
                    ),
                    GestureDetector(
                      onTap: () {
                        push(
                          context,
                          LogInScreen(),
                        );
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor1),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * .01,
                ),
              ],
            ),
    );
  }
}

// import 'package:country_ip/country_ip.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:lyon/screen/auth/login/login_page.dart';
// import 'package:lyon/screen/auth/signup/cubit/signup_cubit.dart';
// import 'package:lyon/screen/auth/signup/cubit/signup_state.dart';
// import 'package:lyon/shared/Widgets/button.dart';
// import 'package:lyon/shared/mehod/message.dart';
// import 'package:lyon/shared/mehod/switch_sreen.dart';
// import 'package:lyon/shared/styles/colors.dart';

// class SignupUser extends StatelessWidget {
//   const SignupUser({Key? key}) : super(key: key);

//   Future<String?> getUserCountryCode() async {
//     final countryIpResponse = await CountryIp.find();
//     return countryIpResponse?.countryCode.toString() ?? '';
//   }

//   Future<void> _selectDate(
//       BuildContext context, TextEditingController date) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(1900),
//         lastDate: DateTime.now());
//     if (picked != null) {
//       date.text = "${picked.year}/${picked.month}/${picked.day}";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     TextEditingController firstName = TextEditingController();
//     TextEditingController lastName = TextEditingController();
//     TextEditingController email = TextEditingController();
//     TextEditingController password = TextEditingController();
//     TextEditingController confirmPassword = TextEditingController();
//     TextEditingController date = TextEditingController();
//     TextEditingController phoneController = TextEditingController();

//     String selectedCurrency = 'JOR';
//     String? countryCode;
//     return BlocProvider(
//       create: (context) => SignupCubit(),
//       child: BlocConsumer<SignupCubit, SignupState>(
//         listener: (context, state) {
//           if (state is SignupSuccess) {
//             // Navigate to the OTP screen
//             // Get.to(() => NewVerifyOTP());
//           }
//           if (state is SignupError) {
//             showMessage(context: context, text: state.message);
//           }
//         },
//         builder: (context, state) {
//           return Form(
//             key: _formKey,
//             child: state is SignupLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Column(
//                     children: [
//                       // First Name and Last Name
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _buildTextField(
//                             isName: true,
//                             context: context,
//                             controller: firstName,
//                             hintText: "first_name".tr,
//                             textValidatorEmpty: "please_enter_first_name".tr,
//                             icon: Icons.account_circle,
//                           ),
//                           _buildTextField(
//                             isName: true,
//                             context: context,
//                             controller: lastName,
//                             hintText: "last_name".tr,
//                             textValidatorEmpty: "please_enter_last_name".tr,
//                             icon: Icons.account_circle,
//                           ),
//                         ],
//                       ),
//                       // Phone Number Field
//                       _buildPhoneField(
//                         context: context,
//                         phoneController: phoneController,
//                         onCountryCodeChanged: (code) {
//                           countryCode =
//                               code; // Capture the selected country code
//                         },
//                       ),
//                       // Email Field
//                       _buildTextField(
//                         context: context,
//                         controller: email,
//                         hintText: "email".tr,
//                         textValidatorEmpty: "please_enter_email".tr,
//                         textValidatorEmail: "please_enter_correct_email".tr,
//                         icon: Icons.email,
//                       ),
//                       // Password Field
//                       _buildTextField(
//                         context: context,
//                         controller: password,
//                         hintText: "password".tr,
//                         textValidatorEmpty: "please_enter_password".tr,
//                         obscureText: true,
//                         icon: Icons.lock,
//                       ),
//                       // Confirm Password Field
//                       _buildTextField(
//                         context: context,
//                         controller: confirmPassword,
//                         hintText: "confirm_password".tr,
//                         textValidatorEmpty: "please_enter_confirm_password".tr,
//                         obscureText: true,
//                         icon: Icons.lock,
//                       ),
//                       // Birthdate Field
//                       _buildTextField(
//                         context: context,
//                         controller: date,
//                         hintText: "birthdate".tr,
//                         textValidatorEmpty: "please_enter_birthdate".tr,
//                         fun: () => _selectDate(context, date),
//                         icon: Icons.calendar_month,
//                       ),
//                       // Currency Dropdown
//                       _buildCurrencyDropdown(
//                         onChanged: (currency) {
//                           selectedCurrency = currency ?? 'JOR';
//                         },
//                       ),
//                       //Devider
//                       const Divider(
//                         color: Color(0xFF0066b3),
//                         thickness: 0.20,
//                       ),
//                       // Signup Button
//                       button(
//                         context: context,
//                         text: "signup".tr,
//                         function: () {
//                           if (_formKey.currentState!.validate()) {
//                             getUserCountryCode().then((cuntryCode) {
//                               BlocProvider.of<SignupCubit>(context).signUp(
//                                 firstName: firstName.text,
//                                 lastName: lastName.text,
//                                 phone: phoneController.text,
//                                 email: email.text,
//                                 password: password.text,
//                                 birthdate: date.text,
//                                 currency: selectedCurrency,
//                                 countryCode: countryCode.toString(),
//                               );
//                             });
//                           }
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "already have an account?".tr,
//                             style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w400,
//                                 color: Color.fromARGB(255, 86, 85, 85)),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               push(
//                                 context,
//                                 LogInScreen(),
//                               );
//                             },
//                             child: Text(
//                               "Login".tr,
//                               style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                   color: secondaryColor1),
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required BuildContext context,
//     required TextEditingController controller,
//     required String hintText,
//     required String textValidatorEmpty,
//     String? textValidatorEmail,
//     bool obscureText = false,
//     Function? fun,
//     bool isName = false,
//     required IconData icon,
//   }) {
//     return SizedBox(
//       width: isName
//           ? MediaQuery.of(context).size.width * 0.44
//           : MediaQuery.of(context).size.width * 0.9,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextFormField(
//           showCursor: true,
//           controller: controller,
//           obscureText: obscureText,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return textValidatorEmpty;
//             } else if (textValidatorEmail != null &&
//                 !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
//               return textValidatorEmail;
//             }
//             return null;
//           },
//           decoration: InputDecoration(
//             suffixIcon: Icon(icon),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: secondaryColor1),
//             ),
//             hintText: hintText,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: secondaryColor1),
//             ),
//           ),
//           onTap: fun as void Function()?,
//         ),
//       ),
//     );
//   }

//   Widget _buildPhoneField({
//     required BuildContext context,
//     required TextEditingController phoneController,
//     required Function(String countryCode) onCountryCodeChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: secondaryColor1),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 6),
//         child: InternationalPhoneNumberInput(
//           inputBorder: InputBorder.none,
//           inputDecoration: InputDecoration(
//             hintText: "enter_your_phone_number".tr,
//             border: InputBorder.none,
//           ),
//           selectorConfig: const SelectorConfig(
//             selectorType: PhoneInputSelectorType.DIALOG,
//             useEmoji: true,
//           ),
//           onInputChanged: (PhoneNumber value) {
//             onCountryCodeChanged(value.dialCode ?? '');
//           },
//           initialValue: PhoneNumber(isoCode: 'JO'),
//           textFieldController: phoneController,
//         ),
//       ),
//     );
//   }

//   Widget _buildCurrencyDropdown({
//     required Function(String?) onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButtonFormField<String>(
//         hint: Text(
//           "please_choose_currency".tr,
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         elevation: 2,
//         iconEnabledColor: Colors.black45,
//         isExpanded: true,
//         focusColor: Colors.transparent,
//         decoration: const InputDecoration(
//           enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: secondaryColor1),
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: secondaryColor1),
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           errorBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: secondaryColor1),
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//         ),
//         items: <String>[
//           'JOD',
//           'USD',
//           'EUR',
//           'AED',
//           'GBP',
//           'SAR',
//           'KWD',
//           'BHD',
//           'OMR',
//           'QAR',
//         ].map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//         onChanged: onChanged,
//         validator: (value) {
//           return value == null ? 'please_choose_currency'.tr : null;
//         },
//       ),
//     );
//   }
// }
