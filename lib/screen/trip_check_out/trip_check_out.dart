import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/api/api.dart';
import 'package:lyon/other/choose_one_image.dart';
import 'package:lyon/other/payment_page_transpotation.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/trip_check_out_controller.dart/trip_check_out_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripCheckOut extends StatefulWidget {
  const TripCheckOut({
    super.key,
    required this.pickupSpot,
    required this.dropOffSpot,
    required this.totalPrice,
    this.locationTicket,
    required this.startDate,
    required this.startTime,
    required this.vehicleType,
    this.destination,
    this.currency,
    this.wayType,
  });
  final String pickupSpot;
  final dropOffSpot;
  final locationTicket;
  final startDate;
  final startTime;
  final vehicleType;
  final destination;
  final currency;
  final wayType;
  final String totalPrice;

  @override
  State<TripCheckOut> createState() => _TripCheckOutState();
}

class _TripCheckOutState extends State<TripCheckOut> {
  //late bool displayPassportButton;
  TripCheckOutController tripCheckOutController = Get.find();
  bool isComingFromAirport() {
    if (widget.pickupSpot.trim() == "Airport Queen Alia" ||
        widget.pickupSpot.trim() == "Queen Alia Airport" ||
        widget.pickupSpot.trim() == "مطار الملكه عليا" ||
        widget.pickupSpot.trim() == "مطار الملكة علياء") {
      return true;
    } else {
      return false;
    }
  }

  // Future<bool> getAPIResponse() async {
  //   var response = await tripCheckOutController.checkIfUserInsertedPassport();
  //   displayPassportButton = response;
  //   print("Heyy: $displayPassportButton");
  //   return response;
  // }

  getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token');
    String apiUrl = ApiApp.checkUserDocuments;
    final json = {"token": _sharedToken, "mobile": "1"};

    http.Response response =
        await http.post(Uri.parse(apiUrl), body: json).whenComplete(() {
      setState(() {
        //isLoading = false;
      });
    });

    var jsonResponse = jsonDecode(response.body);
    print("Response: $jsonResponse");
    return jsonResponse;
  }

  var futurePost;

  @override
  void initState() {
    print(widget.destination);
    // TODO: implement initState
    super.initState();
    print(widget.destination);
    futurePost = getToken();
    asyncFunc();
    if (widget.pickupSpot.trim() ==
            "Airport Queen Alia" || //this is same as calling the isComingFromAirport-funtion.
        widget.pickupSpot.trim() == "Queen Alia Airport" ||
        widget.pickupSpot.trim() == "مطار الملكه عليا" ||
        widget.pickupSpot.trim() == "مطار الملكه علياء") {
      tripCheckOutController.displayTicketButton.value = true;
    } else {
      tripCheckOutController.displayTicketButton.value = false;
    }
    tripCheckOutController.displayThankfulMessageInTrip.value = false;
  }

  void displayThanksIfUserIsNotComingFromAirport() async {
    bool? passporInserted =
        await tripCheckOutController.checkIfUserInsertedPassport();
    if (!isComingFromAirport() && passporInserted) {
      tripCheckOutController.displayThankfulMessageInTrip.value = true;
    } else if (isComingFromAirport() && passporInserted) {
      if (tripCheckOutController.displayTicketButton.value == false) {
        tripCheckOutController.displayThankfulMessageInTrip.value = true;
      }
    }
  }

  void asyncFunc() async {
    await tripCheckOutController.checkIfUserInsertedPassport();
  }

  @override
  Widget build(BuildContext context) {
    displayThanksIfUserIsNotComingFromAirport();
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
                      padding: EdgeInsets.only(top: 50.0, bottom: 10.0),
                      child: Obx(
                        () => Center(
                          child: tripCheckOutController
                                  .displayThankfulMessageInTrip.value
                              ? Text(
                                  "Thank You! Press continue",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                )
                              : Text(
                                  "Please attach the below photos: ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                        ),
                      )),
                  //visibility-widget -of-->Ticket button --IF--> the Pickup spot was from Queen Alia.
                  //the above ticket widget is always visible when ever the user inserts the pickUp spot as -QueenAlia-
                  Obx(
                    () => Visibility(
                      visible:
                          tripCheckOutController.displayPassportButton.value,
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
                                                  "comingFromTrip",
                                            )))
                                    .then((value) => value
                                        ? setState(
                                            () {
                                              futurePost = getToken();
                                            },
                                          )
                                        : null);
                              }),
                        ),
                      ),
                    ),
                  ),

                  //visibility-widget -of-->Passport button --IF--> the passport is not attached previously.
                  //the above passport widget will only be visible if the passport widget in the Database is not inserted previously
                  Visibility(
                    visible:
                        (widget.pickupSpot.trim() == "Airport Queen Alia" ||
                                    widget.pickupSpot.trim() ==
                                        "Queen Alia Airport" ||
                                    widget.pickupSpot
                                            .trim() ==
                                        "مطار الملكه عليا" ||
                                    widget.pickupSpot.trim() ==
                                        "مطار الملكه علياء") &&
                                tripCheckOutController.displayTicketButton.value
                            ? true
                            : false,
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
                                                  "comingFromTrip",
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
                  Obx(() => Center(
                        child: button(
                            context: context,
                            text: tripCheckOutController
                                    .displayThankfulMessageInTrip.value
                                ? "Continue"
                                : "confirm".tr,
                            function: () async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeCap: StrokeCap.square,
                                        strokeWidth: 5,
                                      ),
                                    );
                                  });
                              var passportInserted =
                                  await tripCheckOutController
                                      .checkIfUserInsertedPassport();
                              print("Response: $passportInserted");
                              print(tripCheckOutController
                                  .displayTicketButton.value);

                              //if the user (pickUp spot) from airport
                              //--then-> check if his ticket && passport is inserted successfully
                              //--navigate him-> to PaymentPage (else)-> CheckOutPage
                              if (widget.pickupSpot.trim() ==
                                      "Airport Queen Alia" ||
                                  widget.pickupSpot.trim() ==
                                      "مطار الملكه عليا" ||
                                  widget.pickupSpot.trim() ==
                                      "مطار الملكه علياء" ||
                                  widget.pickupSpot.trim() ==
                                      "Queen Alia Airport") {
                                if (passportInserted &&
                                    tripCheckOutController
                                            .displayTicketButton.value ==
                                        false) {
                                  Navigator.of(context).pop();
                                  print(
                                      "Heyy: ${widget.pickupSpot} ${widget.destination}");
                                  push(
                                      context,
                                      CashOrVisaTranspotation(
                                        locationTicket: widget.locationTicket,
                                        startDate: widget.startDate,
                                        startTime: widget.startTime,
                                        totalPrice: widget.totalPrice,
                                        vehicleType: widget.vehicleType,
                                        currency: widget.currency,
                                        wayType: widget.wayType,
                                        destination: widget.destination,
                                        startLocation: widget.pickupSpot,
                                        endLocation: widget.dropOffSpot,
                                      ));
                                } else {
                                  Navigator.of(context).pop();
                                  showMessage(
                                    context: context,
                                    text:
                                        "Please insert the above attachements",
                                  );
                                }
                              } else {
                                print("Passport inserted: $passportInserted");
                                if (passportInserted) {
                                  Navigator.of(context).pop();
                                  print(
                                      "Heyy: ${widget.pickupSpot} ${widget.destination}");
                                  push(
                                    context,
                                    CashOrVisaTranspotation(
                                      locationTicket: widget.locationTicket,
                                      startDate: widget.startDate,
                                      startTime: widget.startTime,
                                      totalPrice: widget.totalPrice,
                                      vehicleType: widget.vehicleType,
                                      currency: widget.currency,
                                      wayType: widget.wayType,
                                      destination: widget.destination,
                                      startLocation: widget.pickupSpot,
                                      endLocation: widget.destination,
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pop();

                                  showMessage(
                                    context: context,
                                    text:
                                        "Please insert the above attachements",
                                  );
                                }
                              }

                              //elseIf the user (pickUp spot) !airport
                              //--then-> check if his passport is inserted successfully
                              //--navigate him-> to PaymentPage (else)-> CheckOutPage
                            }),
                      ))
                ],
              );
            }
          })),
    );
  }
}
