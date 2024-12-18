import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/screen/auth/signup/sigup_page.dart';
import 'package:lyon/other/main_screen.dart';
import 'package:lyon/other/setting.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/method_sharedprefernce.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/utils/Translate/localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutus.dart';
import 'account_statement_date.dart';
import '../screen/auth/edit_information.dart';
import '../screen/auth/login/login_page.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class DrawerWidget extends StatefulWidget {
  bool? isGuest = false;
  DrawerWidget({super.key, this.isGuest = false});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String name = '';
  String email = '';
  String appName = '';
  String version = '';

  getNameAndEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPreferences.getString("name") ?? "";
      email = sharedPreferences.getString("email") ?? "";
    });
  }

  getVersionAndAppName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String version = packageInfo.version;
    setState(() {
      this.appName = appName;
      this.version = version;
    });
  }

  @override
  void initState() {
    if (widget.isGuest == false) {
      getNameAndEmail();
      getVersionAndAppName();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          LocalizationService().getCurrentLocale() == const Locale('ar', 'AE')
              ? const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  bottomLeft: Radius.circular(50.0))
              : const BorderRadius.only(
                  topRight: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .75,
        child: Drawer(
          backgroundColor: backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: secondaryColor1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (widget.isGuest == false)
                          Text(
                            name,
                            style: const TextStyle(
                                color: colorPrimary, fontSize: 20),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          "assets/images/logo.png",
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.height / 4,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (widget.isGuest == false)
                          Text(
                            email,
                            style: const TextStyle(
                                color: colorPrimary, fontSize: 16),
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.isGuest == true)
                  contentDrawer(
                      context: context,
                      text: "login".tr,
                      function: () {
                        push(context, LogInScreen());
                        //About us
                      },
                      icon: const Icon(
                        Icons.login,
                        color: secondaryColor1,
                        size: 30,
                      )),

                if (widget.isGuest == true)
                  contentDrawer(
                      context: context,
                      text: "signup".tr,
                      function: () {
                        push(context, const SignupPage());
                        //About us
                      },
                      icon: const Icon(
                        Icons.app_registration,
                        color: secondaryColor1,
                        size: 30,
                      )),
                contentDrawer(
                    context: context,
                    text: "about_us".tr,
                    function: () {
                      push(context, const AboutUs());
                      //About us
                    },
                    icon: const Icon(
                      Icons.person,
                      color: secondaryColor1,
                      size: 30,
                    )),
                if (widget.isGuest == false)
                  contentDrawer(
                      context: context,
                      text: "edit_profile".tr,
                      function: () {
                        push(context, const EditInformation());

                        //About us
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: secondaryColor1,
                        size: 30,
                      )),
                contentDrawer(
                    context: context,
                    text: "contact_us".tr,
                    function: () {
                      push(
                          context,
                          MainScreen(
                            numberIndex: 4,
                          ));
                    },
                    icon: const Icon(
                      Icons.contact_page_outlined,
                      color: secondaryColor1,
                      size: 30,
                    )),
                if (widget.isGuest == false)
                  contentDrawer(
                      context: context,
                      text: "account_statment".tr,
                      function: () {
                        push(context,
                            AccountStatementDate(accountType: 'customer'));
                      },
                      icon: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: secondaryColor1,
                        size: 30,
                      )),
                if (widget.isGuest == false)
                  contentDrawer(
                      context: context,
                      text: "setting".tr,
                      function: () {
                        push(context, const Setting());
                      },
                      icon: const Icon(
                        Icons.settings_rounded,
                        color: secondaryColor1,
                        size: 30,
                      )),
                if (widget.isGuest == false)
                  contentDrawer(
                      context: context,
                      text: "delete_account".tr,
                      function: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: Column(
                                    children: [
                                      Text(
                                        'are_you_sure_to_delete_your_account'
                                            .tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all<
                                                        Color>(secondaryColor1),
                                                shape: WidgetStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ))),
                                            child: Text(
                                              "no".tr,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              String apiUrl =
                                                  ApiApp.deactivateAccount;
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              var sharedToken = prefs
                                                  .getString('access_token');
                                              final json = {
                                                "token": sharedToken,
                                              };
                                              removeSharedPreference();
                                              var box = GetStorage();
                                              box.write(
                                                  "isFaceIdEnabled", false);
                                              pushAndRemoveUntil(
                                                  // ignore: use_build_context_synchronously
                                                  context, LogInScreen());
                                              showMessage(
                                                  // ignore: use_build_context_synchronously
                                                  context: context,
                                                  text:
                                                      'Deleted account successflly');
                                              // ignore: unused_local_variable
                                              http.Response response =
                                                  await http.post(
                                                      Uri.parse(apiUrl),
                                                      body: json);
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all<
                                                        Color>(secondaryColor1),
                                                shape: WidgetStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ))),
                                            child: Text(
                                              "yes".tr,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: secondaryColor1,
                        size: 30,
                      )),

                // contentDrawer(
                //     context: context,
                //     text: "our_location".tr,
                //     function: () {
                //       push(context, OurLocation());
                //       //About us
                //     },
                //     icon: Icon(
                //       Icons.location_on_sharp,
                //       color: secondaryColor1,
                //       size: 30,
                //     )),
                // contentDrawer(
                //     context: context,
                //     text: "help_center".tr,
                //     function: () {
                //       push(context, ChatMessage());
                //       //About us
                //     },
                //     icon: Icon(
                //       Icons.help_outline,
                //       color: secondaryColor1,
                //       size: 30,
                //     )),
                if (widget.isGuest == false)
                  contentDrawer(
                      context: context,
                      text: "logout".tr,
                      function: () {
                        showPopup(
                            context: context,
                            funAccept: () {
                              removeSharedPreference();
                              pushAndRemoveUntil(context, LogInScreen());
                            },
                            funReject: () {
                              Navigator.pop(context);
                            },
                            question: "are_you_sure_to_exit".tr);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: secondaryColor1,
                        size: 30,
                      )),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "$appName $version",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget contentDrawer(
    {required BuildContext context,
    required String text,
    required Widget icon,
    required Function function}) {
  return GestureDetector(
    onTap: () => function(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            children: [
              icon,
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 7,
                child: Text(
                  text,
                  style: styleSecondColor20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
        ],
      ),
    ),
  );
}
