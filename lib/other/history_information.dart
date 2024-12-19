import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/model/get_user_orders_model.dart';
import 'package:lyon/screen/auth/login/login_page.dart';
import 'package:lyon/screen/auth/signup/sigup_page.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/Widgets/custom_text.dart';
import 'main_screen.dart';
import 'order_details_program.dart';
import 'order_details_rental.dart';
import 'order_details_transportation.dart';

// ignore: must_be_immutable
class HistoryInformation extends StatefulWidget {
  bool? isGuest = false;
  HistoryInformation({super.key, this.isGuest = false});

  @override
  // ignore: library_private_types_in_public_api
  _HistoryInformationState createState() => _HistoryInformationState();
}

class _HistoryInformationState extends State<HistoryInformation>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Future<GetUserOrdersModel> futurePost;
  bool isShowDialog = false;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    futurePost = getUserOrders();
  }

  Future<GetUserOrdersModel> getUserOrders() async {
    String apiUrl = ApiApp.getUserOrders;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    logInfo('sharedToken $sharedToken');
    final json = {"token": sharedToken ?? "", "mobile": "1"};

    http.Response response = await http
        .post(Uri.parse(apiUrl), body: json)
        .timeout(const Duration(seconds: 5), onTimeout: () {
      pushAndRemoveUntil(context, MainScreen(numberIndex: 1));
      throw Exception('Cannot connect to the server');
    });
    logWarning(" Orders ${response.body}");

    var jsonResponse = jsonDecode(response.body);

    //print(_sharedToken);
    //setState(() {});

    return GetUserOrdersModel.fromJson(jsonResponse);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future deleteFun(id, statusAllowCanceld, index) async {
    statusAllowCanceld == 0
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Center(
                child: Text(
                  "You Can't Delete This Order beacuse You Will Take Car Within 48 Hours"
                      .tr,
                  style: const TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                    color: Colors.red,
                  ),
                ),
              ));
            })
        : showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("are u sure delete".tr),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "cancel".tr,
                      style: const TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        isShowDialog = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      "delete".tr,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      setState(() {
                        isShowDialog = true;
                      });
                      http.Response response = await http.post(
                          Uri.parse(ApiApp.cancelVisaOrderCompletion),
                          body: {
                            "orderId": id,
                          });
                      var responseBody = jsonDecode(response.body);
                      print(responseBody.toString());
                      if (responseBody["status"] == 200 ||
                          responseBody["status"] == 500) {
                        String apiUrl = ApiApp.deleteOrderByID;

                        http.Response response =
                            await http.post(Uri.parse(apiUrl), body: {
                          "id": id,
                        }).whenComplete(() {
                          Get.offAll(MainScreen(
                            numberIndex: 1,
                          ));
                          setState(() {
                            isShowDialog = false;
                          });
                        });
                        var responseBody = jsonDecode(response.body);
                        showMessage(
                            context: context,
                            text: responseBody["error"].toString());
                      } else {
                        setState(() {
                          isShowDialog = false;
                        });
                        showMessage(
                            context: context,
                            text: "Sorry can't delete this order");
                      }
                    },
                  ),
                ],
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (widget.isGuest == true) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("please_login".tr, style: const TextStyle(fontSize: 18)),
              const SizedBox(
                height: 20,
              ),
              button(
                context: context,
                function: () {
                  push(context, LogInScreen());
                },
                text: "Login".tr,
              ),
              const SizedBox(
                height: 20,
              ),
              button(
                context: context,
                function: () {
                  push(context, const SignupPage());
                },
                text: "Register".tr,
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<GetUserOrdersModel>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  isShowDialog == true) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomText(
                            text: 'date'.tr,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: 'name'.tr,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: 'service'.tr,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: 'status'.tr,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      snapshot.data!.data!.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Slidable(
                                      key:
                                          ValueKey(snapshot.data!.data!.length),
                                      endActionPane: ActionPane(
                                        motion: const StretchMotion(),
                                        children: [
                                          snapshot.data!.data![index].status
                                                      .toString() ==
                                                  "Cancelled"
                                              ? Container()
                                              : snapshot.data!.data![index]
                                                          .isRelayed
                                                          .toString()
                                                          .toLowerCase() ==
                                                      "yes"
                                                  ? SlidableAction(
                                                      autoClose: true,
                                                      onPressed: (_) async {
                                                        String? contractId =
                                                            snapshot
                                                                .data!
                                                                .data![index]
                                                                .contractId;
                                                        if (snapshot
                                                                .data!
                                                                .data![index]
                                                                .service ==
                                                            'Rental') {
                                                          var url =
                                                              "https://lyon-jo.com/api/getContractInvoice.php?id=$contractId";
                                                          if (await canLaunchUrl(
                                                              Uri.parse(url))) {
                                                            await launchUrl(
                                                              Uri.parse(url),
                                                              mode: Platform
                                                                      .isAndroid
                                                                  ? LaunchMode
                                                                      .externalApplication
                                                                  : LaunchMode
                                                                      .platformDefault,
                                                            );
                                                          } else {
                                                            showMessage(
                                                                context:
                                                                    context,
                                                                text:
                                                                    'Can\'t open please try again!');
                                                          }
                                                        } else if (snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .service ==
                                                                'Trip' ||
                                                            snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .service ==
                                                                'Program') {
                                                          var url =
                                                              "https://lyon-jo.com/api/getTransportationInvoice.php?id=$contractId";
                                                          if (await canLaunchUrl(
                                                              Uri.parse(url))) {
                                                            await launchUrl(
                                                              Uri.parse(url),
                                                              mode: Platform
                                                                      .isAndroid
                                                                  ? LaunchMode
                                                                      .externalApplication
                                                                  : LaunchMode
                                                                      .platformDefault,
                                                            );
                                                          } else {
                                                            showMessage(
                                                                context:
                                                                    context,
                                                                text:
                                                                    'Can\'t open please try again!');
                                                          }
                                                        }
                                                      },
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 30, 0, 255),
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons
                                                          .contacts_rounded,
                                                      label: 'Invoice',
                                                    )
                                                  : SlidableAction(
                                                      onPressed: (_) => {
                                                        // IF LEFT DATE IS LESS THAN 00 DAYS 00 HOURS 00 MINUTES DONT DISPLAY DELETE BUTTON
                                                        deleteFun(
                                                            snapshot
                                                                .data!
                                                                .data![index]
                                                                .id,
                                                            snapshot
                                                                .data!
                                                                .data![index]
                                                                .statusAllowCancel,
                                                            index)
                                                      },
                                                      backgroundColor:
                                                          const Color.fromRGBO(
                                                              207, 37, 37, 1),
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.delete,
                                                      label: 'delete'.tr,
                                                    ),
                                          SlidableAction(
                                            autoClose: true,
                                            onPressed: (_) {
                                              if (snapshot.data!.data![index]
                                                      .service
                                                      .toString() ==
                                                  "Rental") {
                                                push(
                                                    context,
                                                    OrderDetailsRental(
                                                        id: snapshot.data!
                                                            .data![index].id!));
                                              } else if (snapshot.data!
                                                      .data![index].service
                                                      .toString() ==
                                                  "Trip") {
                                                push(
                                                    context,
                                                    OrderDetailsTransportation(
                                                        id: snapshot.data!
                                                            .data![index].id!));
                                              } else if (snapshot.data!
                                                      .data![index].service
                                                      .toString() ==
                                                  "Program") {
                                                push(
                                                    context,
                                                    OrderDetailsProgram(
                                                      id: snapshot.data!
                                                          .data![index].id!,
                                                    ));
                                              }
                                            },
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    15, 186, 178, 1),
                                            foregroundColor: Colors.white,
                                            icon: Icons.info,
                                            label: 'details'.tr,
                                          ),
                                        ],
                                      ),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .1,
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    CustomText(
                                                      text: snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .service
                                                                  .toString() ==
                                                              "Trip"
                                                          ? snapshot
                                                              .data!
                                                              .data![index]
                                                              .orderStartDate
                                                              .toString()
                                                          : snapshot.data!
                                                              .data![index].date
                                                              .toString(),
                                                      alignment:
                                                          Alignment.center,
                                                      size: 13,
                                                    ),
                                                    CustomText(
                                                      text: snapshot.data!
                                                          .data![index].name
                                                          .toString(),
                                                      alignment:
                                                          Alignment.center,
                                                      size: 13,
                                                    ),
                                                    CustomText(
                                                      text: snapshot.data!
                                                          .data![index].service
                                                          .toString(),
                                                      alignment:
                                                          Alignment.center,
                                                      size: 13,
                                                    ),
                                                    CustomText(
                                                      text: snapshot.data!
                                                          .data![index].status
                                                          .toString(),
                                                      alignment:
                                                          Alignment.center,
                                                      size: 13,
                                                      color: snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .status
                                                                  .toString() ==
                                                              'Approved'
                                                          ? Colors.green
                                                          : snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .status
                                                                      .toString() ==
                                                                  'On Hold'
                                                              ? Colors.orange
                                                              : Colors.red,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.red,
                                                  highlightColor:
                                                      Colors.grey.shade100,
                                                  enabled: true,
                                                  period: const Duration(
                                                      seconds: 5),
                                                  direction:
                                                      ShimmerDirection.rtl,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .paymentMethod
                                                                  .toString() ==
                                                              "0"
                                                          ? (snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .isRelayed
                                                                          .toString()
                                                                          .toLowerCase() ==
                                                                      "yes" ||
                                                                  snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .status
                                                                          .toString() ==
                                                                      "Cancelled" ||
                                                                  int.parse(snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .timeLeft!
                                                                          .split(
                                                                              ":")[0]) <
                                                                      0)
                                                              ? const SizedBox()
                                                              : CustomText(
                                                                  size: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03,
                                                                  text:
                                                                      "${'You can cancel this booking in'.tr} ${snapshot.data!.data![index].timeLeft!.split(":")[0]} ${'days'.tr} ${snapshot.data!.data![index].timeLeft!.split(":")[1]} ${'hours'.tr} ${snapshot.data!.data![index].timeLeft!.split(":")[2]} ${'minutes'.tr}.",
                                                                  color: Colors
                                                                          .red,
                                                                      
                                                                )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              })
                          : Center(
                              child:
                                  Text('you_do_not_have_any_reservations'.tr))
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      );
    }
  }
}
