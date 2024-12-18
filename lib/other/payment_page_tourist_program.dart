import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lyon/other/inappview.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';
import '../shared/mehod/message.dart';
import 'main_screen.dart';

enum PaymentMethod { cashOnDelivery, bankTransfer }

class CashOrVisaTouristProgram extends StatefulWidget {
  final String totalPrice;
  // ignore: prefer_typing_uninitialized_variables
  final result;
  // ignore: prefer_typing_uninitialized_variables
  final currency;

  // ignore: prefer_typing_uninitialized_variables
  final vehicleType;
  final locationTicket;

  const CashOrVisaTouristProgram(
      {super.key,
      required this.totalPrice,
      required this.result,
      this.currency,
      this.locationTicket,
      this.vehicleType});
  @override
  // ignore: library_private_types_in_public_api
  _CashOrVisaTouristProgramState createState() =>
      _CashOrVisaTouristProgramState();
}

class _CashOrVisaTouristProgramState extends State<CashOrVisaTouristProgram> {
  PaymentMethod paymentMethod = PaymentMethod.cashOnDelivery;
  bool iBanNumber = false;
  bool isLoadingCreateOrder = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

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
                        text: 'total'.tr,
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        // ignore: prefer_interpolation_to_compose_strings
                        text: '${widget.totalPrice}  ' + widget.currency,
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: height * .05),
                  SizedBox(
                    width: width * 0.45,
                    height: height * 0.06,
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
                        String apiUrl = ApiApp.createOrder;
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var token = prefs.getString('access_token');
                        var json = {
                          "token": token,
                          'trip': jsonEncode(widget.result),
                          "mobile": "1",
                          'totalPrice': widget.totalPrice.toString(),
                          "paymentMethod": paymentMethod.name,
                          "orderType": "Program", // convert to Program
                          "vehicleType": widget.vehicleType,
                          "Date":
                              widget.result[0]['Date'].toString(),
                          "Time":
                              widget.result[0]['Time'].toString()
                        };
                        logInfo(json.toString());
                        http.Response response = await http
                            .post(Uri.parse(apiUrl), body:json,)
                            .whenComplete(() {
                          setState(() {
                            isLoadingCreateOrder = false;
                          });
                        });
                        var jsonResponse = jsonDecode(response.body);
                        logInfo(jsonResponse.toString());
                        if (jsonResponse['status'] == 0) {
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
                                'https://lyon-jo.com/api/VisaPayment.php?mobile=1&token=$token';
                            await push(
                                    context,
                                    MyInAppWebView(
                                      url: url,
                                    ))
                                .whenComplete(() {});
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
