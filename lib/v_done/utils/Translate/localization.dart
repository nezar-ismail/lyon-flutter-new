// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lyon/v_done/utils/Translate/en_US.dart';

import 'ar_AE.dart';

class LocalizationService extends Translations {
  // ignore: prefer_const_constructors
  static final local = Locale('en', 'US');
  // ignore: prefer_const_constructors
  static final fallBackLocale = Locale('en', 'US');

  static final langs = ['English', 'Arabic'];
  static final locales = [
    const Locale('en', 'US'),
    const Locale('ar', 'AE'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'ar_AE': arAE,
      };

  void changeLocale(String lang) {
    final locale = getLocale(lang);
    final box = GetStorage();
    box.write('lng', lang);
    if (locale != null) {
      Get.updateLocale(locale); 
    }
  }

  Locale? getLocale(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }

    return Get.locale;
  }

  Locale getCurrentLocale() {
    final box = GetStorage();
    Locale defaultLocale;

    if (box.read('lng') != null) {
      final locale = getLocale(box.read('lng'));

      defaultLocale = locale!;
    } else {
      defaultLocale = const Locale('en', 'US');
    }

    return defaultLocale;
  }

  String getCurrentLang() {
    final box = GetStorage();

    // ignore: prefer_if_null_operators
    return box.read('lng') != null ? box.read('lng') : 'English';
  }
}
