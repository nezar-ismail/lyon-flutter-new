import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lyon/screen/company/other/home_page_company.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:video_player/video_player.dart';
import '../screen/auth/login/login_page.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String token = '';
  String tokenCompany = '';
  bool isCompanyLoggedIn = false;
  bool withRental = false;
  bool withTrip = false;
  bool withFullDay = false;

  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      tokenCompany =
          sharedPreferences.getString('access_token_company').toString();
      if (kDebugMode) {
        print(tokenCompany);
      }
      if (tokenCompany.isNotEmpty && tokenCompany != '') {
        isCompanyLoggedIn = true;
      }
      withRental = sharedPreferences.getBool('withRental') ?? false;
      withTrip = sharedPreferences.getBool('withTrip') ?? false;
      withFullDay = sharedPreferences.getBool('withFullDay') ?? false;

      token = sharedPreferences.getString('access_token').toString();
    });
  }

  late VideoPlayerController _controller;
  @override
  void initState() {
    getToken();
    _controller = VideoPlayerController.asset("assets/images/lyonSplash.mp4")
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.0);
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tokenCompany.isNotEmpty &&
          isCompanyLoggedIn &&
          tokenCompany != 'null') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
            return HomePageCompany();
          }),
          (route) => false,
        );
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) {
                return token == 'null' || token.isEmpty || token == ''
                    ? LogInScreen()
                    : MainScreen(
                        numberIndex: 0,
                      );
              }),
              (route) => false,
            );
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          height: MediaQuery.of(context).size.height / 2,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
