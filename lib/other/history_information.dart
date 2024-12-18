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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
  late List<Timer> timers;
  Timer? time;
  List<int> hours = List.generate(100, (index) => 0);
  List<int> minutes = List.generate(100, (index) => 0);
  List<int> seconds = List.generate(100, (index) => 0);
  List<int> days = List.generate(100, (index) => 0);
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    futurePost = getUserOrders();
    timers = []; // Initialize the list to store timers
    futurePost.then((value) {
      hours = List.generate(value.data!.length, (index) => 0);
      minutes = List.generate(value.data!.length, (index) => 0);
      seconds = List.generate(value.data!.length, (index) => 0);
      days = List.generate(value.data!.length, (index) => 0);
      for (int i = 0; i < value.data!.length; i++) {
        Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
          if (!mounted) return; // Ensure the widget is still mounted
          DateTime orderDate;
          if (value.data![i].service == 'Trip') {
            orderDate = DateTime(
              int.parse(value.data![i].orderStartDate!.split("/")[0]),
              int.parse(value.data![i].orderStartDate!.split("/")[1]),
              int.parse(value.data![i].orderStartDate!.split("/")[2]),
            );
          } else {
            orderDate = DateTime(
              int.parse(value.data![i].date!.split("/")[0]),
              int.parse(value.data![i].date!.split("/")[1]),
              int.parse(value.data![i].date!.split("/")[2]),
            );
          }

          if (value.data![i].status.toString() == "Cancelled" ||
              value.data![i].status.toString() == "On Hold") {
            setState(() {
              hours[i] = 0;
              minutes[i] = 0;
              seconds[i] = 0;
              days[i] = 0;
            });
            return;
          } else {
            setState(() {
              hours[i] = orderDate.difference(DateTime.now()).inHours;
              minutes[i] = orderDate.difference(DateTime.now()).inMinutes % 60;
              seconds[i] = orderDate.difference(DateTime.now()).inSeconds % 60;
              days[i] = orderDate.difference(DateTime.now()).inDays;
            });
          }
        });
        timers.add(timer); // Add the timer to the list
      }
    });
  }

  Future<GetUserOrdersModel> getUserOrders() async {
    String apiUrl = ApiApp.getUserOrders;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    final json = {"token": sharedToken ?? "", "mobile": "1"};

    http.Response response = await http
        .post(Uri.parse(apiUrl), body: json)
        .timeout(const Duration(seconds: 5), onTimeout: () {
      pushAndRemoveUntil(context, MainScreen(numberIndex: 1));
      throw Exception('Cannot connect to the server');
    });
    var jsonResponse = jsonDecode(response.body);
    print(response.body);

    //print(_sharedToken);
    //setState(() {});

    return GetUserOrdersModel.fromJson(jsonResponse);
  }

  @override
  void dispose() {
    tabController.dispose();
    for (var timer in timers) {
      timer.cancel(); // Cancel all timers
    }
    super.dispose();
  }

  Future deleteFun(id, order, index) async {
    DateTime now = DateTime.now();
    DateTime orderDate;
    if (order[index].service.toString() == 'Trip') {
      orderDate = DateTime(
          int.parse(order[index].orderStartDate!.split("/")[0]),
          int.parse(order[index].orderStartDate!.split("/")[1]),
          int.parse(order[index].orderStartDate!.split("/")[2]));
    } else {
      orderDate = DateTime(
          int.parse(order[index].date!.split("/")[0]),
          int.parse(order[index].date!.split("/")[1]),
          int.parse(order[index].date!.split("/")[2]));
    }

    orderDate.difference(now).inHours < 48
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Center(
                child: Text(
                  "You Can't Delete This Order beacuse You Will Take Car Within ${orderDate.difference(now).inHours < 0 ? orderDate.difference(now).inHours * -1 : orderDate.difference(now).inHours} hours",
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
                title: orderDate.difference(now).inHours < 48
                    ? Text(
                        "You Cant Delete This Order beacuse it's below ${orderDate.difference(now).inHours} hours")
                    : Text("are u sure delete".tr),
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
                                return Slidable(
                                  key: ValueKey(snapshot.data!.data!.length),
                                  endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      snapshot.data!.data![index].status
                                                  .toString() ==
                                              "Cancelled"
                                          ? Container()
                                          : snapshot.data!.data![index]
                                                      .isRelayed
                                                      .toString() ==
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
                                                            context: context,
                                                            text:
                                                                'Can\'t open please try again!');
                                                      }
                                                    } else if (snapshot
                                                                .data!
                                                                .data![index]
                                                                .service ==
                                                            'Trip' ||
                                                        snapshot
                                                                .data!
                                                                .data![index]
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
                                                            context: context,
                                                            text:
                                                                'Can\'t open please try again!');
                                                      }
                                                    }
                                                  },
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 30, 0, 255),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.contacts_rounded,
                                                  label: 'Invoice',
                                                )
                                              : SlidableAction(
                                                  onPressed: (_) => {
                                                    if (snapshot
                                                                .data!
                                                                .data![index]
                                                                .status
                                                                .toString() ==
                                                            "Cancelled" ||
                                                        snapshot
                                                                .data!
                                                                .data![index]
                                                                .status
                                                                .toString() ==
                                                            "On Hold")
                                                      {
                                                        setState(() {
                                                          print("New");
                                                        }),
                                                      },
                                                    deleteFun(
                                                        snapshot.data!
                                                            .data![index].id,
                                                        snapshot.data!.data!,
                                                        index)
                                                  },
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          207, 37, 37, 1),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'delete'.tr,
                                                ),
                                      SlidableAction(
                                        autoClose: true,
                                        onPressed: (_) {
                                          if (snapshot
                                                  .data!.data![index].service
                                                  .toString() ==
                                              "Rental") {
                                            push(
                                                context,
                                                OrderDetailsRental(
                                                    id: snapshot.data!
                                                        .data![index].id!));
                                          } else if (snapshot
                                                  .data!.data![index].service
                                                  .toString() ==
                                              "Trip") {
                                            push(
                                                context,
                                                OrderDetailsTransportation(
                                                    id: snapshot.data!
                                                        .data![index].id!));
                                          } else if (snapshot
                                                  .data!.data![index].service
                                                  .toString() ==
                                              "Program") {
                                            push(
                                                context,
                                                OrderDetailsProgram(
                                                  id: snapshot
                                                      .data!.data![index].id!,
                                                ));
                                          }
                                        },
                                        backgroundColor: const Color.fromRGBO(
                                            15, 186, 178, 1),
                                        foregroundColor: Colors.white,
                                        icon: Icons.info,
                                        label: 'details'.tr,
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .1,
                                    child: Card(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CustomText(
                                            text: snapshot.data!.data![index]
                                                        .service
                                                        .toString() ==
                                                    "Trip"
                                                ? snapshot.data!.data![index]
                                                    .orderStartDate
                                                    .toString()
                                                : snapshot
                                                    .data!.data![index].date
                                                    .toString(),
                                            alignment: Alignment.center,
                                            size: 13,
                                          ),
                                          CustomText(
                                            text: snapshot
                                                .data!.data![index].name
                                                .toString(),
                                            alignment: Alignment.center,
                                            size: 13,
                                          ),
                                          CustomText(
                                            text: snapshot
                                                .data!.data![index].service
                                                .toString(),
                                            alignment: Alignment.center,
                                            size: 13,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              snapshot.data!.data![index]
                                                          .paymentMethod
                                                          .toString() ==
                                                      "0"
                                                  ? ((hours[index] == 0 &&
                                                              minutes[index] ==
                                                                  0 &&
                                                              seconds[index] ==
                                                                  0 &&
                                                              days[index] ==
                                                                  0) ||
                                                          snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .contractId !=
                                                              "" ||
                                                          snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .isRelayed
                                                                  .toString() ==
                                                              "Yes")
                                                      ? const SizedBox()
                                                      : CustomText(
                                                          size: 14,
                                                          text:
                                                              "${(hours[index]).round() < 0 ? (hours[index]).round() * -1 : (hours[index]).round()}:${(minutes[index] % 60).round()}:${(seconds[index] % 60).round()}",
                                                          color: hours[index] <
                                                                  48
                                                              ? Colors.black
                                                              : Colors.black,
                                                        )
                                                  : SizedBox(),
                                              CustomText(
                                                text: snapshot
                                                    .data!.data![index].status
                                                    .toString(),
                                                alignment: Alignment.center,
                                                size: 13,
                                                color: snapshot.data!
                                                            .data![index].status
                                                            .toString() ==
                                                        'Approved'
                                                    ? Colors.green
                                                    : snapshot
                                                                .data!
                                                                .data![index]
                                                                .status
                                                                .toString() ==
                                                            'On Hold'
                                                        ? Colors.orange
                                                        : Colors.red,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
