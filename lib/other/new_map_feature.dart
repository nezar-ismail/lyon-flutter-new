import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io' show Platform;
import 'package:android_intent_plus/android_intent.dart';

// ignore: must_be_immutable
class NewMapScreen extends StatefulWidget {
  NewMapScreen({super.key});
  bool backButton = false;
  String? lat;
  String? long;

  @override
  State<NewMapScreen> createState() => _NewMapScreenState();
}


class _NewMapScreenState extends State<NewMapScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.785,
            child: Stack(children: [
              InAppWebView(
                onLoadStop:
                    (InAppWebViewController controller, Uri? uri) async {
                  if (uri
                      .toString()
                      .startsWith('https://www.google.com/maps/place/')) {
                    widget.lat = uri.toString().split('/@')[1].split(',')[0];
                    widget.long = uri
                        .toString()
                        .split('/@')[1]
                        .split(',')[1]
                        .split('/')[0];
                  }
                  if (uri
                      .toString()
                      .startsWith('https://www.google.com/maps/dir//')) {
                    widget.lat = uri
                        .toString()
                        .split('https://www.google.com/maps/dir//')[1]
                        .split(',')[0];
                    widget.long = uri
                        .toString()
                        .split('https://www.google.com/maps/dir//')[1]
                        .split(',')[1]
                        .split('/')[0];
                  }
                  if (uri.toString() ==
                      'https://www.google.com/maps/d/viewer?mid=1ajIB-ImN5Jp12CQoRpzrZfyP1JEupBA&femb=1&ll=31.79712255890801%2C35.920615079427854&z=11') {
                    setState(() {
                      widget.backButton = false;
                    });
                  }

                  if (uri.toString() !=
                      'https://www.google.com/maps/d/viewer?mid=1ajIB-ImN5Jp12CQoRpzrZfyP1JEupBA&femb=1&ll=31.79712255890801%2C35.920615079427854&z=11') {
                    setState(() {
                      widget.backButton = true;
                    });

                    if (uri.toString().startsWith('intent://')) {
                      // await _launchInWebView(uri ?? Uri.parse(''));

                      var platform = Platform.isAndroid;
                      if (platform) {
                        AndroidIntent intent = AndroidIntent(
                            action: 'action_view',
                            data: Uri.encodeFull(
                                'google.navigation:q=${widget.lat}, ${widget.long}&avoid=tf'),
                            package: 'com.google.android.apps.maps');
                        await intent.launch();
                        controller.goBack();
                        controller.goBack();
                      }
                    }
                  }
                },
                onPageCommitVisible:
                    (InAppWebViewController controller, Uri? uri) {
                  controller.evaluateJavascript(source: """
              var style = document.createElement('style');
              style.innerHTML = ".OFA0We-HzV7m.OFA0We-haAclf{ display: none; }.Te60Vd-ZMv3u.dIxMhd-bN97Pc-b3rLgd{ display: none !important; }.gbt{ display: none !important; }.QA0Szd-s2gQvd-bN97Pc{disaplay: none  !important;}.HzV7m-tJHJj>.i4ewOd-r4nke{display:none !important}.gdGlUc-QA0Szd{display:none !important}";
              document.head.appendChild(style);
          """);
                },
                initialUrlRequest: URLRequest(
                  url: WebUri(
                      'https://www.google.com/maps/d/viewer?mid=1ajIB-ImN5Jp12CQoRpzrZfyP1JEupBA&femb=1&ll=31.79712255890801%2C35.920615079427854&z=11'),
                ),
                onCreateWindow: (controller, createWindowRequest) async {
                  var uri = createWindowRequest.request.url.toString();

                  if (uri.startsWith('intent://')) {
                    var platform = Platform.isAndroid;
                    if (platform) {
                      AndroidIntent intent = AndroidIntent(
                        action: 'action_view',
                        data: uri,
                      );
                      await intent.launch();
                    }

                  }
                  uri.toString();
                  return null;
                },
              ),

              // widget.backButton
              //     ? Center(
              //         child: Positioned(
              //           top: 20,
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: button(
              //                 context: context,
              //                 text: "Return to map",
              //                 function: () {
              //                   push(context, MainScreen(numberIndex: 3));
              //                 }),
              //           ),
              //         ),
              //       )
              //     : Container()
            ]),
          ),
        ],
      ),
    );
  }
}
