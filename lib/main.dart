import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lyon/amount_controller.dart/amount_controller.dart';
import 'package:lyon/check_out_controller.dart/check_out_controller.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/services/local_notification_service.dart';
import 'package:lyon/v_done/utils/firebase_options.dart';
import 'package:lyon/screen/Translate/localization.dart';
import 'package:lyon/other/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:lyon/other/splash_screen.dart';
import 'package:lyon/tourism_check_out_controller.dart/tourism_check_out_controller.dart';
import 'package:lyon/trip_check_out_controller.dart/trip_check_out_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo.fromPlatform();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    FirebaseMessaging.onBackgroundMessage(NotificationService.firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    const timePickerTheme = TimePickerThemeData(
      hourMinuteTextStyle: TextStyle(fontFamily: 'Roboto', fontSize: 50),
      dayPeriodTextStyle: TextStyle(fontFamily: 'Roboto'),
    );

    return GetMaterialApp(
      translations: LocalizationService(),
      locale: LocalizationService().getCurrentLocale(),
      fallbackLocale: const Locale('en', 'US'),
      title: 'LYON',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          timePickerTheme: timePickerTheme,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
            backgroundColor: secondaryColor1,
            elevation: 5,
          ),),
      builder: EasyLoading.init(),
      initialRoute: '/',
      routes: {
        '/NotificationScreen': (context) =>
            MainScreen(numberIndex: 2),
        '/': (context) => const SplashScreen(),
      },

      initialBinding: BindingsBuilder(() {
        Get.put(AmountController());
        Get.put(CheckOutController());
        Get.put(TripCheckOutController());
        Get.put(TourismCheckOutController());
      }),
    );
  }
}
