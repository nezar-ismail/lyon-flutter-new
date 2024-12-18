import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/api/api.dart';
import 'package:lyon/model/company_model/get_order_total_price_company_model.dart';
import 'package:lyon/screen/company/other/hestory/history_orders_company.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DetailsFullDayCompany extends StatefulWidget {
  String startDate;
  String endDate;
  String customerName;
  String projectName;
  String phoneNumber;
  String vehicleName;
  int totalPrice;
  int pricePerDay;
  int numberOfDay;
  String currency;
  String vehicleimage;
  String numberVechile;
  DetailsFullDayCompany(
      {super.key,
      required this.customerName,
      required this.endDate,
      required this.vehicleimage,
      required this.phoneNumber,
      required this.projectName,
      required this.startDate,
      required this.vehicleName,
      required this.totalPrice,
      required this.pricePerDay,
      required this.currency,
      required this.numberOfDay,
      required this.numberVechile});

  @override
  State<DetailsFullDayCompany> createState() => _DetailsFullDayCompanyState();
}

class _DetailsFullDayCompanyState extends State<DetailsFullDayCompany> {
  late Future<GetOrderPriceCompanyModel> futureGetOrderPrice;
  bool isLoading = false;

  // @override
  // void initState() {
  //   futureGetOrderPrice = getOrderTotalPrice();
  //   super.initState();
  // }

  // Future<GetOrderPriceCompanyModel> getOrderTotalPrice() async {
  //   String apiUrl = ApiApp.getOrderTotalPrice;

  //   http.Response response = await http.post(Uri.parse(apiUrl), body: json);

  //   var jsonResponse = jsonDecode(response.body);
  //   // return GetOrderPriceCompanyModel.fromJson(jsonResponse);
  // }

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
        body:

            //     : FutureBuilder<GetOrderPriceCompanyModel>(
            //         future: futureGetOrderPrice,
            //         builder: (context, snapshot) {
            //           if (snapshot.connectionState == ConnectionState.waiting) {
            //             return const Center(child: CircularProgressIndicator());
            //           } else if (snapshot.hasError || snapshot.data?.status == 0) {
            //             return const Center(
            //               child: Text("please check time and date",
            //                   style: TextStyle(
            //                       fontSize: 16, fontWeight: FontWeight.bold)),
            //             );
            //           } else {
            //             return
            isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: _height * .02,
                        ),
                        Center(
                            child: Image.network(
                          'https://lyon-jo.com/' + widget.vehicleimage,
                          width: MediaQuery.of(context).size.width / 2,
                        )),
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
                                  DataCell(Text('number_of_vehicle'.tr)),
                                  DataCell(
                                      Text(widget.numberVechile.toString())),
                                ]),
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
                                  DataCell(Text('return_date'.tr)),
                                  DataCell(Text(widget.endDate.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('number_of_days'.tr)),
                                  DataCell(Text(widget.numberOfDay.toString())),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('price_day'.tr)),
                                  DataCell(Text(widget.pricePerDay.toString() +
                                      '  ' +
                                      widget.currency)),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('total_price_2'.tr)),
                                  DataCell(Text(widget.totalPrice.toString() +
                                      '  ' +
                                      widget.currency)),
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
                                'submit'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                SharedPreferences _prefs =
                                    await SharedPreferences.getInstance();
                                var _sharedToken =
                                    _prefs.getString('access_token_company');
                                Map<String, dynamic> json = {
                                  'mobile': '1',
                                  'token': _sharedToken,
                                  'projectName': widget.projectName,
                                  'Vehicle': widget.vehicleName,
                                  'startDate': widget.startDate.toString(),
                                  'endDate': widget.endDate.toString(),
                                  'customerName': widget.customerName,
                                  'phoneNumber': widget.phoneNumber,
                                  'pricePerDay': widget.pricePerDay.toString(),
                                  'total_price': widget.totalPrice.toString(),
                                  "currency": widget.currency,
                                  "VehicleNumber": widget.numberVechile
                                };

                                String apiUrl =
                                    ApiApp.createCompanyOrderFullDay;
                                http.Response response = await http
                                    .post(Uri.parse(apiUrl), body: json)
                                    .whenComplete(() => setState(() {
                                          isLoading = false;
                                        }));

                                var jsonResponse = jsonDecode(response.body);
                                showMessage(
                                    context: context,
                                    text: jsonResponse['message']);
                                push(context, const HistoryOrdersCompany());
                              },
                            )),
                      ],
                    ),
                  )
        // }
        );
  }
}
