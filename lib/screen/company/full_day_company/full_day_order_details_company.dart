import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/model/company_model/full_day_order_details_model.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/styles/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class FullDayOrderDetailsCompany extends StatefulWidget {
  final String id;

  const FullDayOrderDetailsCompany({super.key, required this.id});
  @override
  _FullDayOrderDetailsCompanyState createState() =>
      _FullDayOrderDetailsCompanyState();
}

class _FullDayOrderDetailsCompanyState
    extends State<FullDayOrderDetailsCompany> {
  late Future<FullDayOrderDetailsCompanyModel> _future;
  @override
  void initState() {
    _future = getDetails();
    super.initState();
  }

  Future<FullDayOrderDetailsCompanyModel> getDetails() async {
    String apiUrl = ApiApp.getCompanyOrderDetails;
    final json = {"id": widget.id, 'mobile': '1'};

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    var x = FullDayOrderDetailsCompanyModel.fromJson(jsonResponse);
    return x;
  }

  // getCompanyProfile() async {
  //   String apiUrl = ApiApp.getCompanyProfile;
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   var _sharedToken = _prefs.getString('access_token_company');
  //   final json = {"token": _sharedToken, 'mobile': '1'};

  //   http.Response response = await http.post(Uri.parse(apiUrl), body: json);
  //   var jsonResponse = jsonDecode(response.body);
  //   setState(() {
  //     cc = jsonResponse;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order_details'.tr),
        centerTitle: true,
        backgroundColor: secondaryColor1,
      ),
      body: FutureBuilder<FullDayOrderDetailsCompanyModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.data != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Center(
                        child: Image.network(
                      'https://lyon-jo.com/' +
                          snapshot.data!.data!.vehicleImagePath!,
                      width: MediaQuery.of(context).size.width / 2,
                    )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
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
                            const DataColumn(
                                label: Text(
                              'car_name',
                            )),
                            DataColumn(
                                label: Text(
                                    snapshot.data!.data!.vehicleType.toString(),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                .03,
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text('number_of_vehicle'.tr)),
                              DataCell(Text(snapshot.data!.data!.numberOfVehicle
                                  .toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('company_name'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.comanyName.toString())),
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
                              DataCell(Text(
                                  snapshot.data!.data!.phoneNumber.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('service'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.orderType.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('order_date'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.createIn.toString())),
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
                              DataCell(Text('price_day'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.pricePerDay.toString() +
                                      '  ' +
                                      snapshot.data!.currency.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('number_of_days'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.numberOfDay.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('total_price_2'.tr)),
                              DataCell(Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                    snapshot.data!.data!.totalPrice.toString() +
                                        '  ' +
                                        snapshot.data!.currency.toString()),
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
