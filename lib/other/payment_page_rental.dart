import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lyon/model/create_order_model.dart';
import 'package:lyon/other/inappview.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';
import 'main_screen.dart';

enum PaymentMethod { cashOnDelivery, bankTransfer }

class CashOrVisa extends StatefulWidget {
  final String totalPrice;
  // ignore: prefer_typing_uninitialized_variables
  final startDate;
  // ignore: prefer_typing_uninitialized_variables
  final startTime;
  // ignore: prefer_typing_uninitialized_variables
  final endDate;
  // ignore: prefer_typing_uninitialized_variables
  final endTime;
  // ignore: prefer_typing_uninitialized_variables
  final startLocation;
  // ignore: prefer_typing_uninitialized_variables
  final endLocation;
  // ignore: prefer_typing_uninitialized_variables
  final isCheckedList;
  // ignore: prefer_typing_uninitialized_variables
  final carId;
  // ignore: prefer_typing_uninitialized_variables
  final pricePerDay;
  // ignore: prefer_typing_uninitialized_variables
  final inOrOutSide;
  // ignore: prefer_typing_uninitialized_variables
  final currency;

  const CashOrVisa(
      {super.key,
      required this.totalPrice,
      required this.startDate,
      required this.startTime,
      required this.endDate,
      required this.endTime,
      required this.startLocation,
      required this.endLocation,
      required this.isCheckedList,
      required this.carId,
      required this.pricePerDay,
      required this.inOrOutSide,
      this.currency});
  @override
  // ignore: library_private_types_in_public_api
  _CashOrVisaState createState() => _CashOrVisaState();
}

class _CashOrVisaState extends State<CashOrVisa> {
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

                  // Visibility(
                  //     visible: iBanNumber,
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           children: [
                  //             SizedBox(
                  //               width: _width * .02,
                  //             ),
                  //             const CustomText(
                  //               text: 'IBan : ',
                  //               // size: 20,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //             const Flexible(
                  //               child: SelectableText(
                  //                 'JO 13 JIBA 0610 0019 4727 8410 4000 05',
                  //                 // maxLine: 2,
                  //                 // minLines: 1,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         // Container(
                  //         //     margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  //         //     child: Divider(
                  //         //       color: Colors.black,
                  //         //     )),
                  //       ],
                  //     )),
                  // SizedBox(height: _height * .05),
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
                        text: '${widget.totalPrice}  ' +
                            widget.currency,
                        size: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: height * .02),

                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Icon(
                        //       Icons.check,
                        //       color: secondaryColor1,
                        //     ),
                        //     const SizedBox(
                        //       width: 5,
                        //     ),
                        //     Expanded(
                        //       child: Text(
                        //         "rental_term_1".tr,
                        //         style: const TextStyle(
                        //             color: Color.fromARGB(255, 84, 84, 84),
                        //             fontSize: 16),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        //const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check,
                              color: secondaryColor1,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text("rental_term_2".tr,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 84, 84, 84),
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check,
                              color: secondaryColor1,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text("rental_term_3".tr,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 84, 84, 84),
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check,
                              color: secondaryColor1,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text("rental_term_4".tr,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 84, 84, 84),
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * .02),
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

                        String apiUrl = ApiApp.createOrder;

                        final json = {
                          "startDate": widget.startDate,
                          "startTime": widget.startTime,
                          "endDate": widget.endDate,
                          "endTime": widget.endTime,
                          "startLocation":
                              widget.startLocation == 'مطار الملكه علياء'
                                  ? "Queen Alia Airport"
                                  : widget.startLocation == 'عمان'
                                      ? "Amman"
                                      : widget.startLocation == 'جسر الملك حسين'
                                          ? "King Hussien Bridge"
                                          : widget.startLocation,
                          "endLocation":
                              widget.endLocation == 'مطار الملكه علياء'
                                  ? "Queen Alia Airport"
                                  : widget.endLocation == 'عمان'
                                      ? "Amman"
                                      : widget.endLocation == 'جسر الملك حسين'
                                          ? "King Hussien Bridge"
                                          : widget.endLocation,
                          "extraItems": jsonEncode(widget.isCheckedList),
                          "totalPrice": widget.totalPrice,
                          "carID": widget.carId,
                          "token": sharedToken,
                          "pricePerDay": widget.pricePerDay.toString(),
                          "location": widget.inOrOutSide,
                          "paymentMethod": paymentMethod.name,
                          "mobile": '1',
                        };


                        http.Response response = await http
                            .post(Uri.parse(apiUrl), body: json)
                            .whenComplete(() {
                          isLoadingCreateOrder = false;
                        });
                        var jsonResponse = CreateOrderModel.fromJson(
                            jsonDecode(response.body));

                        if (jsonResponse.status == 0) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          return showDialog(
                              // ignore: use_build_context_synchronously
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
                            //   print("Heyy");
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
                            // try {
                            await push(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    MyInAppWebView(
                                      url: url,
                                    ))
                                //launchUrl(Uri.parse(url),

                                //          webOnlyWindowName: "Don't Close This")
                                .whenComplete(() {});
                            // } catch (e) {
                            //   print("Error launching URL: $e");
                            //   showMessage(
                            //       context: context,
                            //       text: "Can\'t open please try again!");
                            // }
                          } else {
                            pushAndRemoveUntil(
                                // ignore: use_build_context_synchronously
                                context,
                                MainScreen(
                                  numberIndex: 1,
                                ));
                            showMessage(
                                // ignore: use_build_context_synchronously
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
