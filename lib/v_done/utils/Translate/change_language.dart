import 'package:flutter/material.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'localization.dart';
import 'package:get/get.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  String lang = "";
  String lng = "English";

  @override
  void initState() {
    super.initState();
    lng = LocalizationService().getCurrentLang();
    var loc = LocalizationService().getLocale(lang);
    if (loc.toString() == "ar_AE") {
      setState(() {
        lang = "Arabic";
        // image = "assets/images/uk.png";
        // langText = "En";
      });
    } else {
      setState(() {
        lang = "English";
        // image = "assets/images/jo.png";
        // langText = "Ar";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Change Language".tr,
          style: styleBlack20WithBold,
        ),
        iconTheme: const IconThemeData(color: secondaryColor1),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  LocalizationService().changeLocale("Arabic");
                  setState(() {
                    lang = "Arabic";
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: LocalizationService().getCurrentLocale() ==
                              const Locale('ar', 'AE')
                          ? Colors.grey
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            offset: const Offset(5, 5),
                            color: Colors.grey.shade200)
                      ]),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width * 0.12,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/FlagJordan.png",
                                    ),
                                    fit: BoxFit.fill),
                                shape: BoxShape.circle),
                          ),
                          const Text(
                            "العربية",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      )),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
                onTap: () {
                  LocalizationService().changeLocale("English");
                  setState(() {
                    lang = "English";
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: LocalizationService().getCurrentLocale() ==
                              const Locale('ar', 'AE')
                          ? Colors.white
                          : Colors.grey,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 8,
                            offset: const Offset(5, 5),
                            color: Colors.grey.shade200)
                      ]),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width * 0.12,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/EnglishImage.png",
                                    ),
                                    fit: BoxFit.fill),
                                shape: BoxShape.circle),
                          ),
                          const Text(
                            "English",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      )),
                )),
          ),
        ],
      ),
    );
  }
}
