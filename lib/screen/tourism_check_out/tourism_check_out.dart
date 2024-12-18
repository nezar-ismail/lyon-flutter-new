import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/other/choose_one_image.dart';
import 'package:lyon/other/payment_page_tourist_program.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/tourism_check_out_controller.dart/tourism_check_out_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TourismCheckOut extends StatefulWidget {
  const TourismCheckOut({
    super.key,
    required this.tick,
    this.totalPrice,
    this.locationTicket,
    this.result,
    this.currency,
    this.vehicleType,
  });

  final bool tick;
  final totalPrice;
  final locationTicket;
  final result;
  final currency;
  final vehicleType;

  @override
  State<TourismCheckOut> createState() => _TourismCheckOutState();
}

class _TourismCheckOutState extends State<TourismCheckOut> {
  TourismCheckOutController tourismCheckOutController = Get.find();

  var futurePost;
  getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token');
    String apiUrl = ApiApp.checkUserDocuments;
    final json = {"token": _sharedToken, "mobile": "1"};

    http.Response response =
        await http.post(Uri.parse(apiUrl), body: json).whenComplete(() {
      setState(() {
      });
    });

    print("response.body: ${response.body}");
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  @override
  void initState() {
    super.initState();
    futurePost = getToken();
    if (widget.tick) {
      tourismCheckOutController.displayTicketButton.value = true;
    } else {
      tourismCheckOutController.displayTicketButton.value = false;
    }
    asyncFunc();
  }

  void asyncFunc() async {
    await tourismCheckOutController.checkIfPassportInserted();
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
      body: FutureBuilder(
          future: futurePost,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 50.0,
                      bottom: 10.0,
                    ),
                    child: Center(
                      child: Text(
                        "Please attach the below photos: ",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible:
                          tourismCheckOutController.displayTicketButton.value,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: Center(
                          child: button(
                              context: context,
                              text: "upload_ticket_photo".tr,
                              function: () {
                                //setState()
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => UploadPassportPhoto(
                                              title: "upload_ticket_photo".tr,
                                              whereYouComingFrom:
                                                  "comingFromTourism",
                                            )))
                                    .then((value) => value
                                        ? setState(() {
                                            futurePost = getToken();
                                          })
                                        : null);
                              }),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible:
                          tourismCheckOutController.displayPassportButton.value,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: Center(
                          child: button(
                              context: context,
                              text: "upload_passport_id_photos".tr,
                              function: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => UploadPassportPhoto(
                                            title:
                                                "upload_passport_id_photos".tr,
                                            whereYouComingFrom:
                                                "comingFromTourism")))
                                    .then((value) => value
                                        ? setState(() {
                                            futurePost = getToken();
                                          })
                                        : null);
                              }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: button(
                        context: context,
                        text: "confirm".tr,
                        function: () async {
                          print(widget.locationTicket);
                          if (widget.tick) {
                            if (tourismCheckOutController
                                        .displayTicketButton.value ==
                                    false &&
                                tourismCheckOutController
                                        .displayPassportButton.value ==
                                    false) {
                              push(
                                context,
                                CashOrVisaTouristProgram(
                                    totalPrice: widget.totalPrice.toString(),
                                    locationTicket: widget.locationTicket,
                                    result: widget.result,
                                    currency: widget.currency,
                                    vehicleType: widget.vehicleType),
                              );
                            } else {
                              showMessage(
                                  context: context,
                                  text:
                                      "Something is missin in the above requirements");
                            }
                          } else {
                            if (tourismCheckOutController
                                    .displayPassportButton.value ==
                                false) {
                              push(
                                context,
                                CashOrVisaTouristProgram(
                                    totalPrice: widget.totalPrice.toString(),
                                    locationTicket: widget.locationTicket,
                                    result: widget.result,
                                    currency: widget.currency,
                                    vehicleType: widget.vehicleType),
                              );
                            } else {
                              showMessage(
                                  context: context,
                                  text:
                                      "Something is missing in the above requirements");
                            }
                          }
                        }),
                  )
                ],
              );
            }
          })),
    );
  }
}
