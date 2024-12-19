// ignore_for_file: prefer_typing_uninitialized_variables, duplicate_ignore, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lyon/model/create_order_model.dart';
import 'package:lyon/other/inappview.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';
import '../shared/mehod/message.dart';
import 'main_screen.dart';

enum PaymentMethod { cashOnDelivery, bankTransfer }

class CashOrVisaTranspotation extends StatefulWidget {
  final String totalPrice;
  // ignore: prefer_typing_uninitialized_variables
  final startDate;
  // ignore: prefer_typing_uninitialized_variables
  final startTime;
  // ignore: prefer_typing_uninitialized_variables
  final vehicleType;
  // ignore: prefer_typing_uninitialized_variables
  final destination;
  // ignore: prefer_typing_uninitialized_variables
  final currency;
  // ignore: prefer_typing_uninitialized_variables
  final wayType;
  final locationTicket;
  final startLocation;
  final endLocation;

  const CashOrVisaTranspotation(
      {super.key,
      required this.totalPrice,
      required this.startDate,
      required this.startTime,
      required this.vehicleType,
      required this.destination,
      this.currency,
      this.wayType,
      this.locationTicket,
      required this.startLocation,
      required this.endLocation});
  @override
  _CashOrVisaTranspotationState createState() =>
      _CashOrVisaTranspotationState();
}

class _CashOrVisaTranspotationState extends State<CashOrVisaTranspotation> {
  PaymentMethod paymentMethod = PaymentMethod.cashOnDelivery;
  bool iBanNumber = false;
  bool isLoadingCreateOrder = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "payment".tr,
        ),
        backgroundColor: secondaryColor1,
      ),
      body: isLoadingCreateOrder
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: height * .05,
                  ),
                  CustomText(
                    text: 'payment_method'.tr,
                    size: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  RadioListTile<PaymentMethod>(
                      title: Text('cash_on_delivery'.tr),
                      value: PaymentMethod.cashOnDelivery,
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      }),
                  RadioListTile<PaymentMethod>(
                      title: Text('credit_card'.tr),
                      value: PaymentMethod.bankTransfer,
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      }),
                  SizedBox(
                    height: height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'total_price'.tr,
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        // ignore: prefer_interpolation_to_compose_strings
                        text: '${widget.totalPrice}  ' +
                            widget.currency,
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: height * .05),
                  // ignore: deprecated_member_use
                  SizedBox(
                    width: width * 0.45,
                    height: height * 0.06,
                    // ignore: deprecated_member_use
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoadingCreateOrder = true;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var sharedToken = prefs.getString('access_token');
                        if (kDebugMode) {
                          print(
                            "widget startLocation ${widget.startLocation} widget end ${widget.endLocation} widget.startDate: ${widget.startDate} widget.startTime: ${widget.startTime} widget.vehicleType: ${widget.vehicleType} widget.destination: ${widget.destination} widget.totalPrice: ${widget.totalPrice} widget.locationTicket: ${widget.locationTicket} widget.wayType: ${widget.wayType} paymentMethod: ${paymentMethod.name} _sharedToken: $sharedToken");
                        }
                        String apiUrl = ApiApp.createUserOrder;
                        final json = {
                          "startDate": widget.startDate,
                          "startTime": widget.startTime,
                          "vehicleType": widget.vehicleType,
                          "orderType": "Trip", // convert to Trip
                          "destination": widget.destination,
                          "totalPrice": widget.totalPrice.toString(),
                          "location": widget.locationTicket.toString(),
                          "mobile": "1",
                          "token": sharedToken,
                          "additionalNote": "",
                          "wayType": widget.wayType,
                          "country": "",
                          "paymentMethod": paymentMethod.name,
                          "startLocation":
                              widget.startLocation.toString().trim() ==
                                      "مطار الملكه علياء"
                                  ? "Queen Alia Airport"
                                  : widget.startLocation.toString().trim(),
                          "endLocation": widget.endLocation.toString().trim() ==
                                  "مطار الملكه علياء"
                              ? "Queen Alia Airport"
                              : widget.endLocation.toString().trim(),
                        };
                        if (kDebugMode) {
                          print(json);
                        }
                        http.Response response = await http
                            .post(Uri.parse(apiUrl), body: json)
                            .whenComplete(() {
                          isLoadingCreateOrder = false;
                        });
                        var jsonResponse = CreateOrderModel.fromJson(
                            jsonDecode(response.body));

                        if (jsonResponse.status == 0) {
                          Navigator.pop(context);
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('error'.tr),
                                  content: Text(
                                    jsonResponse.message.toString(),
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  actions: [
                                    // ignore: deprecated_member_use
                                    TextButton(
                                      child: Text("ok".tr),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          setState(() {
                            isLoadingCreateOrder = false;
                          });
                          if (paymentMethod.name == 'bankTransfer') {
                            var url =
                                'https://lyon-jo.com/api/VisaPayment.php?mobile=1&token=$sharedToken';

                            // if (await canLaunchUrl(Uri.parse(url))) {
                            //   await launchUrl(Uri.parse(url)).whenComplete(() {
                            //     pushAndRemoveUntil(
                            //         context,
                            //         MainScreen(
                            //           numberIndex: 1,
                            //         ));
                            //   });
                            // } else {
                            //   showMessage(
                            //       context: context,
                            //       text: 'Can\'t open please try again!');
                            // }
                            //try {
                            await push(
                                    context,
                                    MyInAppWebView(
                                      url: url,
                                    ))
                                //launchUrl(Uri.parse(url),

                                //          webOnlyWindowName: "Don't Close This")
                                .whenComplete(() {});
                            //} catch (e) {
                            //   print(
                            //       "Catched error in the tripPaymentApproach: $e");
                            //   showMessage(
                            //       context: context,
                            //       text: 'Can\'t open please try again!');
                            // }
                          } else {
                            pushAndRemoveUntil(
                                context,
                                MainScreen(
                                  numberIndex: 1,
                                ));
                            showMessage(
                                context: context,
                                text: 'Order created successfully');
                            reviewApp();
                          }
                        }
                      },
                      child: CustomText(
                        alignment: Alignment.center,
                        text: 'checkout'.tr,
                        color: Colors.white,
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

Future reviewApp() async {
  final InAppReview inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    inAppReview.requestReview();
  }
}
