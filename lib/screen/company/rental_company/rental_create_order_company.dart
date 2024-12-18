import 'dart:convert';
import 'package:dio/dio.dart' as prefix;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/api/api.dart';
import 'package:lyon/model/company_model/get_order_total_price_company_model.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../v_done/company/history/history_orders_company.dart';

// ignore: must_be_immutable
class RentalCreateOrderCompany extends StatefulWidget {
  String carId;
  String id;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  String customerName;
  String projectName;
  String phoneNumber;
  String vehicleName;
  String carImage;
  // ignore: prefer_typing_uninitialized_variables
  final licenseImage;
  RentalCreateOrderCompany(
      {super.key,
      required this.carId,
      required this.id,
      required this.customerName,
      required this.endDate,
      required this.endTime,
      required this.licenseImage,
      required this.phoneNumber,
      required this.projectName,
      required this.startDate,
      required this.startTime,
      required this.vehicleName,
      required this.carImage});

  @override
  State<RentalCreateOrderCompany> createState() =>
      _RentalCreateOrderCompanyState();
}

class _RentalCreateOrderCompanyState extends State<RentalCreateOrderCompany> {
  late Future<GetOrderPriceCompanyModel> futureGetOrderPrice;
  var dio = prefix.Dio();
  bool isLoading = false;

  @override
  void initState() {
    futureGetOrderPrice = getOrderTotalPrice();
    super.initState();
  }

  Future<GetOrderPriceCompanyModel> getOrderTotalPrice() async {
    String apiUrl = ApiApp.getOrderTotalPrice;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token_company');
    final json = {
      "startDate": widget.startDate,
      "startTime": widget.startTime,
      "endDate": widget.endDate,
      "endTime": widget.endTime,
      "id": widget.id,
      "mobile": "1",
      "token": _sharedToken
    };

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);

    var jsonResponse = jsonDecode(response.body);
    return GetOrderPriceCompanyModel.fromJson(jsonResponse);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: secondaryColor1,
        title: Text('checkout'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 25)),
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<GetOrderPriceCompanyModel>(
              future: futureGetOrderPrice,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data?.status == 0) {
                  return Center(
                    child: Text("please_check_time_and_date".tr,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: _height * .02,
                        ),
                        Image.network(
                          widget.carImage,
                          width: _width * .5,
                        ),
                        SizedBox(
                          height: _height * .02,
                        ),
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: _width * .03,
                              decoration: BoxDecoration(
                                // color: Colors.grey.shade100,
                                // border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              columns: [
                                DataColumn(
                                    label: Text('vehicle_type'.tr,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text(widget.vehicleName,
                                        // snapshot.data!.data!.numberOfDays.toString(),
                                        style: TextStyle(
                                            fontSize: _width * .03,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text('name'.tr)),
                                  DataCell(
                                      Text(widget.customerName.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('project_name'.tr)),
                                  DataCell(Text(widget.projectName.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('phone_number'.tr)),
                                  DataCell(Text(widget.phoneNumber.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('start_date'.tr)),
                                  DataCell(Text(widget.startDate.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('start_time'.tr)),
                                  DataCell(Text(widget.startTime.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('return_date'.tr)),
                                  DataCell(Text(widget.endDate.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('return_time'.tr)),
                                  DataCell(Text(widget.endTime.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('number_of_days'.tr)),
                                  DataCell(Text(snapshot
                                      .data!.data!.numberOfDays
                                      .toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('price_day'.tr)),
                                  DataCell(Text(snapshot
                                          .data!.data!.pricePerDay!
                                          .toStringAsFixed(0) +
                                      ' ' +
                                      snapshot.data!.currency!)),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('total_price_2'.tr)),
                                  DataCell(Text(snapshot.data!.data!.totalPrice!
                                          .toStringAsFixed(0) +
                                      ' ' +
                                      snapshot.data!.currency!)),
                                ]),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * .02,
                        ),
                        SizedBox(
                            width: _width * .50,
                            height: _height * .05,
                            // ignore: deprecated_member_use
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                'confirm'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                  // total = snapshot.data!.data!.totalPrice;
                                });
                                postOrder(snapshot.data!.data!.totalPrice,
                                    snapshot.data!.data!.pricePerDay);
                              },
                            )),
                      ],
                    ),
                  );
                }
              }),
    );
  }

  postOrder(var total, var pricePerDay) async {
    String apiUrl = ApiApp.addCompanyOrder;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token_company');
    // String _frontImage = image1!.path.split('/').last;
    String _frontImage = widget.licenseImage!.path.split('/').last;

    var formData = prefix.FormData.fromMap({
      "token": _sharedToken,
      "mobile": "1",
      "carId": widget.carId,
      "startDate": widget.startDate,
      "startTime": widget.startTime,
      "endDate": widget.endDate,
      "endTime": widget.endTime,
      "orderType": "Rental",
      "customerName": widget.customerName,
      "projectName": widget.projectName,
      "phoneNumber": widget.phoneNumber,
      "pricePerDay": pricePerDay,
      "totalPrice": total,
      'licenseImage': await prefix.MultipartFile.fromFile(
          widget.licenseImage.path,
          filename: _frontImage),
    });

    await dio.post(apiUrl, data: formData).whenComplete(() {
      // ignore: unnecessary_this
      if (this.mounted) {
        pushReplacement(context, const HistoryOrdersCompany());
        setState(() {
          isLoading = false;
        });
        showMessage(context: context, text: 'order_created_successfully'.tr);
      }
    });
  }
}
