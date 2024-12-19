import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api/api.dart';
import '../model/get_order_details_transportation_model.dart';
import '../shared/Widgets/custom_text.dart';
import '../shared/styles/colors.dart';

class OrderDetailsTransportation extends StatefulWidget {
  final String id;

  const OrderDetailsTransportation({super.key, required this.id});
  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsTransportationState createState() =>
      _OrderDetailsTransportationState();
}

class _OrderDetailsTransportationState
    extends State<OrderDetailsTransportation> {
  late Future<GetOrderDetailsTransportationModel> _future;
  var concatenate = StringBuffer();
  @override
  void initState() {
    _future = getDetails();
    super.initState();
  }

  Future<GetOrderDetailsTransportationModel> getDetails() async {
    String apiUrl = ApiApp.getOrderDetails;
    final json = {
      "id": widget.id,
    };

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);
    var jsonResponse = jsonDecode(response.body);
    if (kDebugMode) {
      print(response.body);
    }

    return GetOrderDetailsTransportationModel.fromJson(jsonResponse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('order_details'.tr),
        centerTitle: true,
        backgroundColor: secondaryColor1,
      ),
      body: FutureBuilder<GetOrderDetailsTransportationModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.data != null) {
              if (kDebugMode) {
                print(snapshot.data!.data!);
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                        child: Image.network(
                      'https://lyon-jo.com/${snapshot.data!.data!.vehicleImage}',
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          columns: [
                            DataColumn(
                                label: Text(
                              'vehicle_type'.tr,
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
                              DataCell(Text('trip2'.tr)),
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  snapshot.data!.data!.waysType.toString(),
                                ),
                              )),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('destination'.tr)),
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  snapshot.data!.data!.destination.toString(),
                                ),
                              )),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('start_date'.tr)),
                              DataCell(Text(
                                  snapshot.data!.data!.startDate.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('start_time'.tr)),
                              DataCell(Text(DateFormat.jm().format(
                                  DateFormat('hh:mm:ss').parse(snapshot
                                      .data!.data!.startTime
                                      .toString())))),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('total_price_2'.tr)),
                              DataCell(Text('${snapshot.data!.data!.totalPrice}  ${snapshot.data!.data!.currency}')),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('payment_method'.tr)),
                              DataCell(Text(snapshot.data!.data!.paymentMethod
                                  .toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('status'.tr)),
                              DataCell(
                                  Text(snapshot.data!.data!.status.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('additional_notes'.tr)),
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(snapshot.data!.data!.additionalNotes
                                    .toString()),
                              )),
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
