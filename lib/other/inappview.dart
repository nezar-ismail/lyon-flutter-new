import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:lyon/other/main_screen.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';

class MyInAppWebView extends StatefulWidget {
  final String url;

  const MyInAppWebView({super.key, required this.url});
  @override
  // ignore: library_private_types_in_public_api
  _MyInAppWebViewState createState() => _MyInAppWebViewState();
}

class _MyInAppWebViewState extends State<MyInAppWebView> {
  bool _canGoBack = false;
  bool _isSucccessfulPage = false;
  int _counter = 14;
  bool isloaded = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    showMessage(context: context, text: "note".tr);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (canGoBack) {
        showMessage(
          context: context,
          text: "note".tr,
        );
        setState(() {
          canGoBack = false;
        });
      },
      canPop: _canGoBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text('payment_title'.tr),
        ),
        body: Stack(children: [
          InAppWebView(
            // onReceivedError: (controller, url, code) {
            // Future.delayed(const Duration(seconds: 5), () {
            // setState(() {
            // _canGoBack = true;
            // showMessage(context: context, text: "");
            // });
            // });
            // },
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            onWebViewCreated: (controller) {
            },
            onLoadStart: (controller, url) {
              setState(() {
                _canGoBack = false;
                isloaded = true;
              });
            },
            onProgressChanged: (controller, progress) {
              if (progress < 70) {
                setState(() {
                  isloaded = false;
                  _canGoBack = true;
                });
              } else {
                setState(() {
                  isloaded = true;
                });
              }
              // if (progress == 100) {}
            },
            onLoadStop: (controller, url) async {
              if (url.toString() ==
                  'https://smartroute.stspayone.com/SmartRoutePaymentWeb/SRPayMsgHandler') {
                setState(() {
                  _canGoBack = true;
                });
              }

              if (url.toString() ==
                      'https://smartroute.stspayone.com/SmartRoutePaymentWeb/PaymentResultServlet' ||
                  url.toString() ==
                      'https://smartroute.stspayone.com/SmartRoutePaymentWeb/ThreeDSEnrollmentResponseServlet') {
                setState(() {
                  _canGoBack = false;
                  _counter = 14;
                  _isSucccessfulPage = true;
                });
                for (var i = 0; i < 15; i++) {
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    _counter == 0 ? _counter : _counter--;
                  });
                }
              }

              if (url.toString() == 'https://lyon-jo.com/responsevisa.php') {
                setState(() {
                  _isSucccessfulPage = false;
                });
                Future.delayed(const Duration(seconds: 3), () {
                  setState(() {
                    _canGoBack = true;
                  });
                  // ignore: use_build_context_synchronously
                  pushAndRemoveUntil(context, MainScreen(numberIndex: 1));
                });
              }
            },
          ),
          // Center(
          //     child: isloaded == false
          //         ? const CircularProgressIndicator()
          //         : const SizedBox()),
          Positioned(
            bottom: 90,
            right: (MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width / 1.25) /
                2,
            child: _isSucccessfulPage
                ? Padding(
                    padding: EdgeInsets.only(
                            right: (MediaQuery.of(context).size.width -
                                    MediaQuery.of(context).size.width / 1.7) /
                                2) /
                        2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width / 1.7,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: secondaryColor1,
                      ),
                      child: Center(
                        child: Text(
                          '${'please_wait'.tr}... $_counter \n${'or_press_submit'.tr}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                // ? Container(
                //     child: GFToast.showToast(
                //         toastDuration: 1,
                //         '${"please_wait".tr}... $_counter \n${"or_press_submit".tr}',
                //         context,
                //         toastPosition: GFToastPosition.BOTTOM,
                //         textStyle: const TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold,
                //             color: GFColors.LIGHT),
                //         backgroundColor: GFColors.DANGER,
                //         trailing: const Icon(
                //           Icons.dangerous,
                //           color: GFColors.WHITE,
                //         )))
                : const SizedBox(),
          ),
          // Center(
          //     child: isloaded == false
          //         ? const CircularProgressIndicator()
          //         : const SizedBox()),
        ]),
      ),
    );
  }
}
