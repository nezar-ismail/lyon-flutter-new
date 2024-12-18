import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/model/company_model/rental_order_details_company_model.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/styles/colors.dart';

class RentalOrderDetailsCompany extends StatefulWidget {
  final String id;

  const RentalOrderDetailsCompany({super.key, required this.id});
  @override
  _RentalOrderDetailsCompanyState createState() =>
      _RentalOrderDetailsCompanyState();
}

class _RentalOrderDetailsCompanyState extends State<RentalOrderDetailsCompany> {
  late Future<RentalOrderDetailsCompanyModel> _future;
  var concatenate = StringBuffer();
  @override
  void initState() {
    _future = getDetails();

    super.initState();
  }

  Future<RentalOrderDetailsCompanyModel> getDetails() async {
    String apiUrl = ApiApp.getCompanyOrderDetails;
    final json = {"id": widget.id, 'mobile': '1'};

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);
    var jsonResponse = jsonDecode(response.body);

    var x = RentalOrderDetailsCompanyModel.fromJson(jsonResponse);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order_details'.tr),
        centerTitle: true,
        backgroundColor: secondaryColor1,
      ),
      body: FutureBuilder<RentalOrderDetailsCompanyModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.data != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                        child: Image.network(
                      'https://lyon-jo.com/${snapshot.data!.data!.carImage}',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height / 5,
                    )),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 5,
                          decoration: BoxDecoration(
                            // color: Colors.grey.shade100,
                            // border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          columns: [
                            DataColumn(
                                label: Text(
                              'car_name'.tr,
                            )),
                            DataColumn(
                                label: Text(
                                    snapshot.data!.data!.carName.toString(),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                .03,
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text('company_name'.tr)),
                              DataCell(
                                  Text(snapshot.data!.data!.name.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('project_name'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.projectName.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('name'.tr)),
                              DataCell(Text(snapshot.data!.data!.customerName
                                  .toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('phone'.tr)),
                              DataCell(
                                  Text(snapshot.data!.data!.phone.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('email'.tr)),
                              DataCell(
                                  Text(snapshot.data!.data!.email.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('service'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.service.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('order_date'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.orderDate.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('start_date'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.startDate.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('end_date'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.endDate.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('start_time'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.startTime.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('end_time'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.endTime.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('price_day'.tr)),
                              DataCell(Text(
                                  '${double.parse(snapshot.data!.data!.pricePerDay!).toStringAsFixed(0)} ${snapshot.data!.currency!}')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('total_price_2'.tr)),
                              DataCell(Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                    '${double.parse(snapshot.data!.data!.totalPrice!).toStringAsFixed(0)} ${snapshot.data!.currency!}'),
                              )),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('status'.tr)),
                              DataCell(
                                  Text(snapshot.data!.data!.status.toString())),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CustomText(
                  text: snapshot.data!.error.toString(),
                  fontWeight: FontWeight.bold,
                  alignment: Alignment.center,
                ),
              );
            }
          }),
    );
  }
}
