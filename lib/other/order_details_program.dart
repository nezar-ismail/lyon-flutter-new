import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/model/get_order_details_program.dart';
import '../api/api.dart';
import '../shared/Widgets/custom_text.dart';
import '../shared/styles/colors.dart';

class OrderDetailsProgram extends StatefulWidget {
  final String id;

  const OrderDetailsProgram({super.key, required this.id});
  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsProgramState createState() => _OrderDetailsProgramState();
}

class _OrderDetailsProgramState extends State<OrderDetailsProgram> {
  late Future<OrderDetailsProgramModel> _future;
  var concatenate = StringBuffer();
  @override
  void initState() {
    _future = getDetails();
    super.initState();
  }

  Future<OrderDetailsProgramModel> getDetails() async {
    String apiUrl = ApiApp.getOrderDetails;
    final json = {
      "id": widget.id,
    };

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);
    var jsonResponse = jsonDecode(response.body);

    var x = OrderDetailsProgramModel.fromJson(jsonResponse);
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
      body: FutureBuilder<OrderDetailsProgramModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data?.data != null) {
              return ListView(
                children: [
                  Center(
                      child: Image.network(
                    'https://lyon-jo.com/${snapshot.data!.data!.vehicleImage}',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 5,
                  )),
                  Center(
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
                          'vehicle_type'.tr,
                        )),
                        DataColumn(
                            label: Text(
                                snapshot.data!.data!.vehicleType.toString(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width * .03,
                                    fontWeight: FontWeight.bold))),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('name'.tr)),
                          DataCell(Text(snapshot.data!.data!.name.toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('phone'.tr)),
                          DataCell(Text(snapshot.data!.data!.phone.toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('email'.tr)),
                          DataCell(Text(snapshot.data!.data!.email.toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('service'.tr)),
                          DataCell(
                              Text(snapshot.data!.data!.service.toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('total_price_2'.tr)),
                          DataCell(Text(
                              '${snapshot.data!.data!.totalPrice}  ${snapshot.data!.data!.currency}')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('payment_method'.tr)),
                          DataCell(Text(
                              snapshot.data!.data!.paymentMethod.toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('status'.tr)),
                          DataCell(
                              Text(snapshot.data!.data!.status.toString())),
                        ]),
                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.data!.trip!.length,
                      itemBuilder: (context, i) {
                        var data = snapshot.data!.data!;
                        return ListTile(
                          title: Text(data.trip![i].destination!),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data.trip![i].date!),
                              Text(data.trip![i].time!),
                            ],
                          ),
                          leading: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: secondaryColor1,
                            child: Text('${i + 1}'),
                          ),
                        );
                      }),
                ],
              );
            } else {
              return Center(
                child: CustomText(
                  text: snapshot.data?.error.toString()??'',
                  fontWeight: FontWeight.bold,
                  alignment: Alignment.center,
                ),
              );
            }
          }),
    );
  }
}
