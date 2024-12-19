// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/check_out_controller.dart/check_out_controller.dart';
import 'package:lyon/other/choose_one_image.dart';
import 'package:lyon/other/payment_page_rental.dart';
import 'package:lyon/other/upload_licnes_image.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewCheckOut extends StatefulWidget {
  const NewCheckOut(
      {super.key,
      required this.pickUpSpot,
      required this.destinationSpot,
      this.totalPrice,
      this.startDate,
      this.startTime,
      this.endDate,
      this.endTime,
      this.isCheckedList,
      this.carId,
      this.pricePerDay,
      this.currency,
      this.inOurOutside});

  final String pickUpSpot;
  final String destinationSpot;
  final totalPrice;
  final startDate;
  final startTime;
  final endDate;
  final endTime;
  final isCheckedList;
  final carId;
  final pricePerDay;
  final currency;
  final inOurOutside;

  @override
  State<NewCheckOut> createState() => _NewCheckOutState();
}

class _NewCheckOutState extends State<NewCheckOut> {
  bool isGoingOrComingFromAirport() {
    if (widget.pickUpSpot.trim() == "Queen Alia Airport" ||
        widget.pickUpSpot.trim() == "مطار الملكه علياء" ||
        widget.pickUpSpot.trim() == "مطار الملكة علياء" ||
        widget.pickUpSpot.trim() == "Queen Alia Airport") {
      return true;
    } else {
      return false;
    }
  }

  CheckOutController controller = Get.find();

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    String apiUrl = ApiApp.checkUserDocuments;
    final json = {"token": sharedToken, "mobile": "1"};

    http.Response response =
        await http.post(Uri.parse(apiUrl), body: json).whenComplete(() {
      setState(() {
        //isLoading = false;
      });
    });

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  var futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = getToken();
    asyncFunc();
    if (isGoingOrComingFromAirport()) {
      controller.askUserForTicketUploading.value = true;
      controller.theUserIsComingOrGoingToAirport.value = true;
    } else {
      controller.askUserForTicketUploading.value = false;
    }
    controller.displayAThankfulMessage.value = false;
    displayingThanksIfUserIsNotComingOrGoingToAirport();
  }

  void displayingThanksIfUserIsNotComingOrGoingToAirport() async {
    String? tempVar = await controller.callTheUserDocumentsAPI();
    if (kDebugMode) {
      print("Here is the tempVariable: $tempVar");
    }
    if (controller.theUserIsComingOrGoingToAirport.value == true) {
      if (tempVar == "All images are attached" &&
          controller.askUserForTicketUploading.value == false) {
        controller.displayAThankfulMessage.value = true;
      }
    } else {
      if (tempVar == "All images are attached") {
        controller.displayAThankfulMessage.value = true;
      }
    }
  }

  void asyncFunc() async {
    await controller.checkTheControllerVariables();
  }

  @override
  Widget build(BuildContext context) {
    //CheckOutController controller = Get.find();
    displayingThanksIfUserIsNotComingOrGoingToAirport();
    if (kDebugMode) {
      print("HII");
    }
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
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
                    child: Center(
                      child: controller.displayAThankfulMessage.value
                          ? const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Text(
                                "Thank you! Press continue",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                            )
                          : const Text(
                              "Please attach the below photos: ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.askUserForLicenseUploading.value,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: Center(
                          child: button(
                              context: context,
                              text: "upload_license_photos".tr,
                              function: () {
                                //setState()
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) =>
                                            const UploadLicnesImage()))
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
                      visible: controller.askUserForPassportUploading.value,
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
                                              title: "upload_passport_id_photos"
                                                  .tr,
                                              whereYouComingFrom:
                                                  "comingFromRental",
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
                  Visibility(
                    visible: controller.askUserForTicketUploading.value,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Center(
                        child: button(
                            context: context,
                            text: "upload_ticket_photo".tr,
                            function: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                        builder: (_) => UploadPassportPhoto(
                                              title: "upload_ticket_photo".tr,
                                              whereYouComingFrom:
                                                  "comingFromRental",
                                            )),
                                  )
                                  .then((value) => value
                                      ? setState(() {
                                          futurePost = getToken();
                                        })
                                      : null);
                            }),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: button(
                        context: context,
                        text: controller.displayAThankfulMessage.value
                            ? "Continue"
                            : "confirm".tr,
                        function: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeCap: StrokeCap.square,
                                    strokeWidth: 5,
                                  ),
                                );
                              });
                          await controller
                              .checkIfLicenseAndPassportAreAttached();
                          if (kDebugMode) {
                            print(
                              "1st var: ${controller.licenseAndPassportAreAttached.value}");
                          }
                          if (kDebugMode) {
                            print(
                              "2nd var: ${controller.askUserForTicketUploading.value}");
                          }

                          if (widget.pickUpSpot == "Queen Alia Airport" ||
                              widget.pickUpSpot == "Queen Alia Airport" ||
                              widget.pickUpSpot.trim() == "مطار الملكه علياء" ||
                              widget.pickUpSpot.trim() == "مطار الملكة علياء") {
                            if (controller
                                    .licenseAndPassportAreAttached.value &&
                                controller.askUserForTicketUploading.value ==
                                    false) {
                              Navigator.of(context).pop();
                              if (kDebugMode) {
                                print(
                                  "${widget.pickUpSpot} - ${widget.destinationSpot}");
                              }

                              push(
                                  context,
                                  CashOrVisa(
                                      totalPrice: widget.totalPrice,
                                      inOrOutSide: "Jordan",
                                      startDate: widget.startDate,
                                      startTime: widget.startTime,
                                      endDate: widget.endDate,
                                      endTime: widget.endTime,
                                      startLocation: widget.pickUpSpot,
                                      endLocation: widget.destinationSpot,
                                      isCheckedList: widget.isCheckedList,
                                      pricePerDay: widget.pricePerDay,
                                      carId: widget.carId,
                                      currency: widget.currency));
                            } else {
                              if (kDebugMode) {
                                print(controller
                                  .licenseAndPassportAreAttached.value);
                              }
                              if (kDebugMode) {
                                print(controller.askUserForTicketUploading.value);
                              }
                              Navigator.of(context).pop();

                              showMessage(
                                  context: context,
                                  text:
                                      "Something missed in the above requirements");
                            }
                          } else if (controller
                              .licenseAndPassportAreAttached.value) {
                            Navigator.of(context).pop();

                            push(
                                context,
                                CashOrVisa(
                                    totalPrice: widget.totalPrice,
                                    inOrOutSide: "Jordan",
                                    startDate: widget.startDate,
                                    startTime: widget.startTime,
                                    endDate: widget.endDate,
                                    endTime: widget.endTime,
                                    startLocation: widget.pickUpSpot,
                                    endLocation: widget.destinationSpot,
                                    isCheckedList: widget.isCheckedList,
                                    pricePerDay: widget.pricePerDay,
                                    carId: widget.carId,
                                    currency: widget.currency));
                          } else {
                            Navigator.of(context).pop();

                            showMessage(
                                context: context,
                                text:
                                    "Something missing in the above requirements");
                          }
                        }),
                  )
                ],
              );
            }
          }),
        ));
  }
}
