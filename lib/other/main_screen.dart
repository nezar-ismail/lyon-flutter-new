import 'package:app_version_update/app_version_update.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lyon/other/new_map_feature.dart';
import 'package:lyon/v_done/services/local_notification_service.dart';
import 'package:lyon/shared/Widgets/appbar.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/mehod/switch_sreen.dart';
import 'contact_us.dart';
import 'drawer.dart';
import 'history_information.dart';
import 'homepage.dart';
import 'offer.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  int numberIndex;
  bool? isGuest = false;
  final String? name;
  MainScreen(
      {super.key, required this.numberIndex, this.name, this.isGuest = false});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;

  late int nummber;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    // checkUpdates();
    getNotificationPermission();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        logInfo('A new onMessageOpenedApp event was published!');
        push(
            // ignore: use_build_context_synchronously
            context,
            MainScreen(
              numberIndex: 2,
            ));
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        NotificationService.displayNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint('A new onMessageOpenedApp event was published!');
      // push(context, const NotificationScreen());

      event.category == 'all'
          ? push(
              // ignore: use_build_context_synchronously
              context,
              MainScreen(
                numberIndex: 2,
              ))
          : push(
              // ignore: use_build_context_synchronously
              context,
              MainScreen(
                numberIndex: 1,
              ));
    });
    super.initState();
  }

Future<void> getNotificationPermission() async {
  // Requesting notification permission
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  // Set foreground notification options
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Initialize local notifications plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

  void checkUpdates() async {
    const appleId =
        '1614812888'; // If this value is null, its packagename will be considered
    const playStoreId =
        "com.lyonjo.company"; // If this value is null, its packagename will be considered
    const country = 'us';
    await AppVersionUpdate.checkForUpdates(
            appleId: appleId, playStoreId: playStoreId, country: country)
        .then((data) async {


      if (data.canUpdate!) {
        await AppVersionUpdate.showAlertUpdate(
            // ignore: use_build_context_synchronously
            context: context,
            appVersionResult: data,
            mandatory: true,
            title: 'New version available',
            titleTextStyle:
                const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
            content:
                'please update application to new version (${data.storeVersion}) to continue',
            contentTextStyle:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            cancelButtonStyle: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.redAccent)),
            updateButtonStyle: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(secondaryColor1)),
            updateButtonText: 'UPDATE',
            cancelTextStyle: const TextStyle(color: Colors.white),
            updateTextStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.white);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(
        numberIndex: 0,
        name: widget.name,
        isGuest: widget.isGuest,
      ),
      HistoryInformation(
        isGuest: widget.isGuest,
      ),
      Offer(
        isGuest: widget.isGuest,
      ),
      NewMapScreen(),
      const ContactUs(),
    ];
    return Scaffold(
      extendBody: true,
      backgroundColor: _page == 3 ? Colors.white : Colors.grey.shade100,
      appBar: AppBars(
        canBack: false,
        withIcon: true,
        context: context,
        text: 'LYON',
        endDrawer: true,
        isGuest: widget.isGuest,
      ),
      drawer: DrawerWidget(isGuest: widget.isGuest),
      body: SingleChildScrollView(
        child: tabs[widget.numberIndex == 1
            ? _page = 1
            : widget.numberIndex == 2
                ? _page = 2
                : widget.numberIndex == 3
                    ? _page = 3
                    : widget.numberIndex == 4
                        ? _page = 4
                        : _page],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: secondaryColor1,
        key: _bottomNavigationKey,
        index: _page,
        height: MediaQuery.of(context).size.height * .07,
        items: <Widget>[
          Icon(
            Icons.home_outlined,
            size: 30,
            color: _page == 0 ? colorPrimary : colorPrimary.withOpacity(.6),
          ),
          Icon(
            Icons.bookmark_added_outlined,
            size: 30,
            color: _page == 1 ? colorPrimary : colorPrimary.withOpacity(.6),
          ),
          Icon(
            Icons.local_offer_outlined,
            size: 30,
            color: _page == 2 ? colorPrimary : colorPrimary.withOpacity(.6),
          ),
          Icon(
            Icons.electrical_services_outlined,
            size: 30,
            color: _page == 3 ? colorPrimary : colorPrimary.withOpacity(.6),
          ),
          Icon(
            Icons.location_on,
            size: 30,
            color: _page == 3 ? colorPrimary : colorPrimary.withOpacity(.6),
          ),
        ],
        color: secondaryColor1,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
            if (_page != 1 || _page != 3) {
              widget.numberIndex = index;
            }
          });
        },
        letIndexChange: (index) => true,
      ),
      floatingActionButton: _page == 3
          ? const SizedBox()
          : GestureDetector(
              onTap: () async {
                var url = Uri.parse("https://wa.me/962777477748");

                if (!await launchUrl(url)) {
                  logError("Could not launch $url");
                  throw Exception('Could not launch $url');
                }
              },
              child: Image.asset(
                "assets/images/whatsapp_logo.png",
                width: MediaQuery.of(context).size.width / 9,
                height: MediaQuery.of(context).size.height / 15,
              ),
            ),
    );
  }
}
