import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lyon/model/company_model/get_orders_company_model.dart';
import 'package:lyon/screen/company/other/hestory/cubit/historu_order_cubit.dart';
import 'package:lyon/screen/company/other/home_page_company.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../../api/api.dart';
import '../../../../shared/Widgets/custom_text.dart';
import '../../../../shared/mehod/switch_sreen.dart';
import '../../../../shared/styles/colors.dart';
import '../../full_day_company/full_day_order_details_company.dart';
import '../../rental_company/rental_order_details_company.dart';
import '../../trip_company/trip_order_details_company.dart';

class HistoryOrdersCompany extends StatefulWidget {
  const HistoryOrdersCompany({super.key});

  @override
  State<HistoryOrdersCompany> createState() => _HistoryOrdersCompanyState();
}

class _HistoryOrdersCompanyState extends State<HistoryOrdersCompany> {
  late Future<GetOrdersCompanyModel> futurePost;
  bool isLoading = false;

  @override
  void initState() {
    futurePost = getAllOrdersCompany();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<GetOrdersCompanyModel> getAllOrdersCompany() async {
    String apiUrl = ApiApp.getCompanyOrders;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token_company');
    final json = {"token": _sharedToken, "mobile": "1"};

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);

    var jsonResponse = jsonDecode(response.body);
    return GetOrdersCompanyModel.fromJson(jsonResponse);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  push(context, HomePageCompany());
                },
                icon: const Icon(Icons.home)),
            centerTitle: true,
            backgroundColor: secondaryColor1,
            title: Text('my_orders'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 25)),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      futurePost = getAllOrdersCompany();
                    });
                  },
                  icon: const Icon(Icons.refresh))
            ],
          ),
          body: isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<GetOrdersCompanyModel>(
                  future: futurePost,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomText(
                                text: 'contract_number'.tr,
                                fontWeight: FontWeight.bold,
                              ),
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
                              ? Expanded(
                                child: ListView.builder(
                                    shrinkWrap: false,
                                    itemCount: snapshot.data!.data!.length,
                                    itemBuilder: (context, index) {
                                      return Slidable(
                                        key:
                                            ValueKey(snapshot.data!.data!.length),
                                        endActionPane: ActionPane(
                                          motion: const StretchMotion(),
                                          extentRatio: snapshot.data!.data![index]
                                                          .status
                                                          .toString() ==
                                                      'Cancelled' &&
                                                  snapshot.data!.data![index]
                                                          .isRelayed
                                                          .toString() ==
                                                      'No'
                                              ? 0.25
                                              : 0.5,
                                          children: [
                                            snapshot.data!.data![index].isRelayed
                                                        .toString() ==
                                                    'yes'
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
                                                              Uri.parse(url));
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
                                                          'Trip') {
                                                        var url =
                                                            "https://lyon-jo.com/api/getTransportationInvoice.php?id=$contractId";
                                                        if (await canLaunchUrl(
                                                            Uri.parse(url))) {
                                                          await launchUrl(
                                                              Uri.parse(url));
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
                                                          'Full Day') {
                                                        var url =
                                                            "https://lyon-jo.com/api/getTransportationInvoice.php?id=$contractId";
                                                        if (await canLaunchUrl(
                                                            Uri.parse(url))) {
                                                          await launchUrl(
                                                              Uri.parse(url));
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
                                                    label: 'invoice'.tr,
                                                  )
                                                : snapshot.data!.data![index]
                                                                .status
                                                                .toString() ==
                                                            "Cancelled" ||
                                                        (snapshot
                                                                    .data!
                                                                    .data![index]
                                                                    .status
                                                                    .toString() ==
                                                                "Approved" &&
                                                            snapshot
                                                                    .data!
                                                                    .data![index]
                                                                    .isRelayed
                                                                    .toString() ==
                                                                'yes')
                                                    ? Container()
                                                    : SlidableAction(
                                                        onPressed: (_) => {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  content: const Text(
                                                                      "Are you sure you want to delete Order?"),
                                                                  actions: <Widget>[
                                                                    // ignore: deprecated_member_use
                                                                    TextButton(
                                                                      child: Text(
                                                                        "cancel"
                                                                            .tr,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                
                                                                    // ignore: deprecated_member_use
                                                                    TextButton(
                                                                      child: Text(
                                                                        "delete"
                                                                            .tr,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              true;
                                                                        });
                                                                        Navigator.of(
                                                                                context)
                                                                            .pop();
                                
                                                                        String
                                                                            apiUrl =
                                                                            ApiApp
                                                                                .deleteCompanyOrder;
                                                                        final json =
                                                                            {
                                                                          "id": snapshot
                                                                              .data!
                                                                              .data![index]
                                                                              .id,
                                                                          'mobile':
                                                                              '1'
                                                                        };
                                
                                                                        http.Response
                                                                            response =
                                                                            await http
                                                                                .post(Uri.parse(apiUrl), body: json)
                                                                                .whenComplete(() {
                                                                          Get.offAll(
                                                                              const HistoryOrdersCompany());
                                                                          setState(
                                                                              () {
                                                                            isLoading =
                                                                                false;
                                                                          });
                                                                        });
                                                                        var responseBody =
                                                                            jsonDecode(
                                                                                response.body);
                                                                        showMessage(
                                                                            context:
                                                                                context,
                                                                            text:
                                                                                responseBody['message']);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              })
                                                          //   }
                                                          // else
                                                          //   {
                                                          //     showMessage(
                                                          //         context: context,
                                                          //         text:
                                                          //             'This Order Already Deleted')
                                                          //   }
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
                                                      RentalOrderDetailsCompany(
                                                          id: snapshot.data!
                                                              .data![index].id!));
                                                } else if (snapshot.data!
                                                        .data![index].service
                                                        .toString() ==
                                                    "Trip") {
                                                  push(
                                                      context,
                                                      TripOrderDetailsCompany(
                                                          id: snapshot.data!
                                                              .data![index].id!));
                                                } else if (snapshot.data!
                                                        .data![index].service
                                                        .toString() ==
                                                    "Full Day") {
                                                  push(
                                                      context,
                                                      FullDayOrderDetailsCompany(
                                                          id: snapshot.data!
                                                              .data![index].id!));
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
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          margin: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade300,
                                                offset: const Offset(
                                                    0.0, 1.0), //(x,y)
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                          ),
                                          width: double.infinity - 5,
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  .1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: CustomText(
                                                  text: snapshot.data!
                                                      .data![index].contractNumber
                                                      .toString(),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: CustomText(
                                                  text: snapshot
                                                      .data!.data![index].date
                                                      .toString(),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: CustomText(
                                                  text: snapshot
                                                              .data!
                                                              .data![index]
                                                              .projectName
                                                              .toString() ==
                                                          "FCSAI transportation service in Amman - Jordan "
                                                      ? "FCSAI service"
                                                      : snapshot
                                                          .data!
                                                          .data![index]
                                                          .projectName
                                                          .toString(),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: CustomText(
                                                  text: snapshot
                                                      .data!.data![index].service
                                                      .toString(),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: CustomText(
                                                  text: snapshot
                                                      .data!.data![index].status
                                                      .toString(),
                                                  alignment: Alignment.center,
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
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                              : Center(
                                  child: Text(
                                      'you_do_not_have_any_reservations'.tr))
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                )),
    );
  }
}