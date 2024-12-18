import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/model/get_order_details_rental_model.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import '../shared/styles/colors.dart';

class OrderDetailsRental extends StatefulWidget {
  final String id;

  const OrderDetailsRental({super.key, required this.id});
  @override
  _OrderDetailsRentalState createState() => _OrderDetailsRentalState();
}

class _OrderDetailsRentalState extends State<OrderDetailsRental> {
  late Future<GetOrderDetailsRentalModel> _future;
  var concatenate = StringBuffer();
  @override
  void initState() {
    _future = getDetails();
    super.initState();
  }

  Future<GetOrderDetailsRentalModel> getDetails() async {
    String apiUrl = ApiApp.getOrderDetails;
    final json = {
      "id": widget.id,
    };

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);
    var jsonResponse = jsonDecode(response.body);

    var x = GetOrderDetailsRentalModel.fromJson(jsonResponse);
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
      body: FutureBuilder<GetOrderDetailsRentalModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.data != null) {
              var ex = json.decode(snapshot.data!.data!.extraItem!);
              print(ex);
              List extraItemsList = [];
              if (ex[0] == true) {
                extraItemsList.add("filling_of_gasoline".tr);
              }
              if (ex[1] == true) {
                extraItemsList.add("car_seat".tr);
              }
              if (ex[2] == true) {
                extraItemsList.add("non_smoking_car".tr);
              }
              if (ex[3] == true) {
                extraItemsList.add("ashtray".tr);
              }
              if (ex[4] == true) {
                extraItemsList.add("insurance".tr);
              }
              if (ex[0] == false &&
                  ex[1] == false &&
                  ex[2] == false &&
                  ex[3] == false &&
                  ex[4] == false) {
                extraItemsList.add("none".tr);
              }
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
                          columnSpacing: 20,
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
                              DataCell(Text('name'.tr)),
                              DataCell(
                                  Text(snapshot.data!.data!.name.toString())),
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
                              DataCell(Text('pick_up_location'.tr)),
                              DataCell(Text(snapshot.data!.data!.startLocation
                                  .toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('drop_off_location'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.endLocation.toString())),
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
                              const DataCell(Text('Extra Items')),
                              DataCell(
                                Text(extraItemsList
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", "")),
                              ),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('total_price_2'.tr)),
                              DataCell(Text(
                                  '${snapshot.data!.data!.totalPrice}  ${snapshot.data!.data!.currency}')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('payment_method'.tr)),
                              DataCell(Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(snapshot.data!.data!.paymentMethod
                                    .toString()),
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
