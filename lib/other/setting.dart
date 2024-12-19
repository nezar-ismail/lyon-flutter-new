import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/other/main_screen.dart';
import 'package:lyon/shared/Widgets/appbar.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/utils/Translate/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool checkSwitch = false;
  bool firstSwitch = false;
  bool secondSwitch = false;
  String? _chosenValue;
  String lang = "";
  String lng = "English";

  @override
  void initState() {
    super.initState();
    lng = LocalizationService().getCurrentLang();
    var loc = LocalizationService().getLocale(lang);
    if (loc.toString() == "ar_AE") {
      setState(() {
        lang = "عربي";
      });
    } else {
      setState(() {
        lang = "English";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBars(
        withIcon: false,
        context: context,
        text: "setting".tr,
        canBack: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 8, right: 8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .08,
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                value: lang,
                underline: const SizedBox(),
                isExpanded: true,
                items: <String>[
                  'English',
                  'عربي',
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
                  "change_language".tr,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onChanged: (value) async {
                  int language = 0;
                  setState(() {
                    lang = value!;
                    if (lang == 'عربي') {
                      language = 1;
                      LocalizationService().changeLocale("Arabic");
                    } else {
                      language = 0;
                      LocalizationService().changeLocale("English");
                    }
                  });
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  var _sharedToken = _prefs.getString('access_token');
                  String apiUrl = ApiApp.changeLanguage;
                  final json = {
                    "language": language.toString(),
                    "token": _sharedToken,
                    "mobile": "1",
                  };

                  await http.post(Uri.parse(apiUrl), body: json);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 8, right: 8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .08,
              child: DropdownButton<String>(
                focusColor: Colors.transparent,
                value: _chosenValue,
                underline: const SizedBox(),
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
                onChanged: (value) async {
                  setState(() {
                    _chosenValue = value;
                  });
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  var _sharedToken = _prefs.getString('access_token');
                  String apiUrl = ApiApp.changeCurrency;

                  final json = {
                    "currency": _chosenValue,
                    "token": _sharedToken,
                    "mobile": "1",
                  };
                  Get.to(MainScreen(
                    numberIndex: 0,
                  ));
                  await http.post(Uri.parse(apiUrl), body: json);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SwitchListTile(
              title: Text(
                "biometrics_activate".tr,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              value: GetStorage().read("isFaceIdEnabled") ?? false,
              onChanged: (bool isOn) {
                var box = GetStorage();

                setState(() {
                  checkSwitch;
                  isOn = !isOn;
                  if (isOn) {
                    box.write("isFaceIdEnabled", false);
                  } else {
                    box.write("isFaceIdEnabled", true);
                  }
                  print(box.read("isFaceIdEnabled") ?? false);
                });
              },
              activeColor: secondaryColor1,
            ),
          ],
        ),
      ),
    );
  }
}
