import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/utils/Translate/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class SettingsCompany extends StatefulWidget {
  const SettingsCompany({super.key});

  @override
  State<SettingsCompany> createState() => _SettingsCompanyState();
}

class _SettingsCompanyState extends State<SettingsCompany> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('setting'.tr),
        backgroundColor: secondaryColor1,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1,
                    )
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  border: Border.all(
                    color: secondaryColor1,
                  )),
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
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black),
                ),
                onChanged: (value) async {
                  setState(() {
                    _chosenValue = value!;
                  });
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var sharedToken = prefs.getString('access_token_company');
                  String apiUrl =
                      "https://lyon-jo.com/api/CompanyCurrencyChange.php";

                  final json = {
                    "currency": _chosenValue,
                    "token": sharedToken,
                    "mobile": "1",
                  };
                  //  Get.to(MainScreen(numberIndex: 0,));
                  await http.post(Uri.parse(apiUrl), body: json);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1,
                  )
                ],
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(color: secondaryColor1),
              ),
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
                  // ignore: unused_local_variable
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
