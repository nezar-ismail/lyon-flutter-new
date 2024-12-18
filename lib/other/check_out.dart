import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:lyon/check_out_controller.dart/check_out_controller.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api.dart';
import 'choose_one_image.dart';
import 'payment_page_rental.dart';
import 'upload_licnes_image.dart';

enum Location { inSideJordan, outSideJordan, kingHussienBridge }

// ignore: must_be_immutable
class CheckOut extends StatefulWidget {
  final bool checkPhoto1;
  final bool checkPhoto2;
  final bool checkPhoto3;
  // ignore: prefer_typing_uninitialized_variables
  final isCheckedList;
  // ignore: prefer_typing_uninitialized_variables
  final totalPrice;
  // ignore: prefer_typing_uninitialized_variables
  final startDate;
  // ignore: prefer_typing_uninitialized_variables
  final endDate;
  // ignore: prefer_typing_uninitialized_variables
  final startTime;
  // ignore: prefer_typing_uninitialized_variables
  final endTime;
  // ignore: prefer_typing_uninitialized_variables
  final startLocation;
  // ignore: prefer_typing_uninitialized_variables
  final endLocation;
  // ignore: prefer_typing_uninitialized_variables
  final carId;
  // ignore: prefer_typing_uninitialized_variables
  final pricePerDay;
  // ignore: prefer_typing_uninitialized_variables
  final currency;
  Location? character;
  CheckOut(
      {super.key,
      this.checkPhoto1 = false,
      this.checkPhoto2 = false,
      this.checkPhoto3 = false,
      this.character,
      this.isCheckedList,
      this.totalPrice,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.startLocation,
      this.endLocation,
      this.carId,
      this.pricePerDay,
      this.currency});

  @override
  // ignore: library_private_types_in_public_api
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  TextEditingController email = TextEditingController();
  List<String> items = ['Jaban', 'Saudia Arabia', 'Emairate'];
  List<String> itemsJordan = ['Amman', 'Aqaba', 'Ajloiun'];
  late String valueOutJordan;
  late String valueInJordan;
  bool isOutJordan = false;
  bool isRiadoChecked = false;
  bool isPassport = false;
  bool isLicnes = false;
  // bool _isBackPressed = false;
  // ignore: prefer_typing_uninitialized_variables
  var futurePost;
  bool _canShowButtonLicense = false;
  bool _canShowButtonPassPort = false;
  bool isCheckUploadImage = false;
  bool _canShowButtonTicket = false;
  bool isLoading = true;

  @override
  void initState() {
    futurePost = getToken();
    //turnTheCheckoutControllerVariableToTrue();
    super.initState();
  }
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    String apiUrl = ApiApp.checkUserDocuments;
    final json = {"token": sharedToken, "mobile": "1"};

    http.Response response =
        await http.post(Uri.parse(apiUrl), body: json).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "checkout".tr,
          ),
          backgroundColor: secondaryColor1,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: futurePost,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            // Text(
                            //   'where_are_you_located'.tr,
                            //   style: const TextStyle(
                            //       fontSize: 20, fontWeight: FontWeight.bold),
                            // ),
                            widget.startLocation == "Amman" ||
                                    widget.startLocation == "عمان"
                                ? RadioListTile<Location>(
                                    title: Text('inside_jordan'.tr),
                                    value: Location.inSideJordan,
                                    groupValue: widget.character,
                                    onChanged: (Location? value) {
                                      setState(() {
                                        widget.character = value;
                                        isRiadoChecked = false;
                                        isOutJordan = false;
                                        if (snapshot.data == 0) {
                                          isLicnes = true;
                                          isPassport = true;
                                        } else if (snapshot.data == 1) {
                                          isLicnes = false;
                                          isPassport = true;
                                        } else if (snapshot.data == 2) {
                                          isLicnes = true;
                                          isPassport = false;
                                        } else if (snapshot.data == 3) {
                                          isLicnes = false;
                                          isPassport = false;
                                        }
                                      });
                                    },
                                  )
                                : Container(),
                            widget.startLocation == "King Hussien Bridge" ||
                                    widget.startLocation == "جسر الملك حسين"
                                ? RadioListTile<Location>(
                                    title: Text('king_hussien_bridge'.tr),
                                    value: Location.kingHussienBridge,
                                    groupValue: widget.character,
                                    onChanged: (Location? value) {
                                      setState(() {
                                        widget.character = value;
                                        isRiadoChecked = false;
                                        isOutJordan = false;
                                        if (snapshot.data == 0) {
                                          isLicnes = true;
                                          isPassport = true;
                                        } else if (snapshot.data == 1) {
                                          isLicnes = false;
                                          isPassport = true;
                                        } else if (snapshot.data == 2) {
                                          isLicnes = true;
                                          isPassport = false;
                                        } else if (snapshot.data == 3) {
                                          isLicnes = false;
                                          isPassport = false;
                                        }
                                      });
                                    },
                                  )
                                : Container(),
                            widget.startLocation == "Queen Alia Airport" ||
                                    widget.startLocation ==
                                        "مطار الملكة علياء" ||
                                    widget.endLocation ==
                                        "Queen Alia Airport" ||
                                    widget.endLocation == "مطار الملكه علياء"
                                ? RadioListTile<Location>(
                                    title: Text('queen_alia_airport'.tr),
                                    value: Location.outSideJordan,
                                    groupValue: widget.character,
                                    onChanged: (Location? value) {
                                      setState(() {
                                        widget.character = value;
                                        isRiadoChecked = false;
                                        isOutJordan = true;
                                        if (snapshot.data == 0) {
                                          isLicnes = true;
                                          isPassport = true;
                                        } else if (snapshot.data == 1) {
                                          isLicnes = false;
                                          isPassport = true;
                                        } else if (snapshot.data == 2) {
                                          isLicnes = true;
                                          isPassport = false;
                                        } else if (snapshot.data == 3) {
                                          isLicnes = false;
                                          isPassport = false;
                                        }
                                      });
                                    },
                                  )
                                : Container(),
                            //the below widget -is a- text displaying "Please choose your location"
                            Visibility(
                                visible: isRiadoChecked,
                                child: Text(
                                  '${'please_choose_your_location'.tr}\n',
                                  style: const TextStyle(color: Colors.red),
                                )),
                            //the below widget -is- for uploading license-i
                            Visibility(
                              visible:
                                  _canShowButtonLicense ? !isLicnes : isLicnes,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                ),
                                child: Center(
                                    child: button(
                                        context: context,
                                        function: () {
                                          setState(() {
                                            isCheckUploadImage = false;
                                            _canShowButtonLicense = true;
                                          });
                                          Navigator.of(context)
                                              .push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const UploadLicnesImage()),
                                              )
                                              .then((val) => val
                                                  ? setState(() {
                                                      futurePost = getToken();
                                                    })
                                                  : null);
                                          // push(context,
                                          //     const UploadLicnesImage());
                                        },
                                        text: "upload_license_photos".tr)),
                              ),
                            ),
                            //the below widget -is- for uploading passport id
                            Visibility(
                              visible: _canShowButtonPassPort
                                  ? !isPassport
                                  : isPassport,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                ),
                                child: Center(
                                    child: button(
                                        context: context,
                                        function: () async {
                                          setState(() {
                                            isCheckUploadImage = false;
                                            _canShowButtonPassPort = true;
                                          });
                                          Navigator.of(context)
                                              .push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        UploadPassportPhoto(
                                                          title:
                                                              'upload_passport_id_photos'
                                                                  .tr,
                                                          whereYouComingFrom:
                                                              "NOT USED CODE - 2",
                                                        )),
                                              )
                                              .then((val) => val
                                                  ? setState(() {
                                                      futurePost = getToken();
                                                    })
                                                  : null);
                                          // final isBackPressed = await push(
                                          //             context,
                                          //             UploadPassportPhoto(
                                          //               title: 'upload_passport_id_photos'.tr,
                                          //             ));
                                          // if (isBackPressed != null &&
                                          //     isBackPressed == true) {
                                          //   setState(() {
                                          //     _isBackPressed = true;
                                          //   });
                                          //   // Call your function here
                                          //   futurePost = getToken();
                                          // }
                                        },
                                        text: "upload_passport_id_photos".tr)),
                              ),
                            ),
                            //the below widget -is- for uploading ticket
                            Visibility(
                              visible: _canShowButtonTicket
                                  ? !isOutJordan
                                  : isOutJordan,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Center(
                                    child: button(
                                        context: context,
                                        function: () {
                                          setState(() {
                                            isCheckUploadImage = false;
                                            _canShowButtonTicket = true;
                                          });
                                          Navigator.of(context)
                                              .push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        UploadPassportPhoto(
                                                          title:
                                                              'upload_ticket_photo'
                                                                  .tr,
                                                          whereYouComingFrom:
                                                              "NOT USED CODE",
                                                        )),
                                              )
                                              .then((val) => val
                                                  ? setState(() {
                                                      futurePost = getToken();
                                                    })
                                                  : null);
                                        },
                                        text: "upload_ticket_photo".tr)),
                              ),
                            ),
                            //the below widget -is a- text displaying "Please upload image"
                            Visibility(
                              visible: isCheckUploadImage,
                              child: Text(
                                'please_upload_images'.tr,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                                child: buttonSmall(
                                    context: context,
                                    text: "confirm".tr,
                                    function: () {
                                      if (widget.character == null) {
                                        setState(() {
                                          isRiadoChecked = true;
                                        });
                                      } else if (_canShowButtonTicket ==
                                              false &&
                                          isOutJordan == true) {
                                        setState(() {
                                          isCheckUploadImage = true;
                                        });
                                      } else {
                                        setState(() {});
                                        if (_canShowButtonLicense == true &&
                                                _canShowButtonPassPort ==
                                                    true ||
                                            snapshot.data == 3) {
                                          setState(() {
                                            isCheckUploadImage = false;
                                          });
                                          String? inOrOutSide;
                                          if (widget.character ==
                                              Location.inSideJordan) {
                                            inOrOutSide = "Jordan";
                                          } else if (widget.character ==
                                              Location.outSideJordan) {
                                            inOrOutSide = "Outside Jordan";
                                          } else if (widget.character ==
                                              Location.kingHussienBridge) {
                                            inOrOutSide = "King Hussien Bridge";
                                          }
                                          push(
                                              context,
                                              CashOrVisa(
                                                  totalPrice: widget.totalPrice,
                                                  inOrOutSide: inOrOutSide,
                                                  startDate: widget.startDate,
                                                  startTime: widget.startTime,
                                                  endDate: widget.endDate,
                                                  endTime: widget.endTime,
                                                  startLocation:
                                                      widget.startLocation,
                                                  endLocation:
                                                      widget.endLocation,
                                                  isCheckedList:
                                                      widget.isCheckedList,
                                                  pricePerDay:
                                                      widget.pricePerDay,
                                                  carId: widget.carId,
                                                  currency: widget.currency));
                                        } else {
                                          setState(() {
                                            isCheckUploadImage = true;
                                          });
                                        }
                                      }
                                      // } else {
                                      //   setState(() {
                                      //     isCheckUploadImage = true;
                                      //   });
                                      // }
                                    }))
                          ],
                        ),
                      ),
                    );
                  }
                },
              ));
  }
}
