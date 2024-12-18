import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/shared/styles/colors.dart';
import '../../../model/company_model/trip_order_details_company_model.dart';

class TripOrderDetailsCompany extends StatefulWidget {
  final String id;

  const TripOrderDetailsCompany({super.key, required this.id});
  @override
  // ignore: library_private_types_in_public_api
  _TripOrderDetailsCompanyState createState() =>
      _TripOrderDetailsCompanyState();
}

class _TripOrderDetailsCompanyState extends State<TripOrderDetailsCompany> {
  late Future<TripOrderDetailsCompanyModel> _future;
  var concatenate = StringBuffer();
  @override
  void initState() {
    _future = getDetails();
    super.initState();
  }

  Future<TripOrderDetailsCompanyModel> getDetails() async {
    String apiUrl = ApiApp.getCompanyOrderDetails;
    final json = {"id": widget.id, 'mobile': '1'};

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);
    var jsonResponse = jsonDecode(response.body);
    var x = TripOrderDetailsCompanyModel.fromJson(jsonResponse);

    return x;
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text('order_details'.tr),
        centerTitle: true,
        backgroundColor: secondaryColor1,
      ),
      body: FutureBuilder<TripOrderDetailsCompanyModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                Center(
                    child: Image.asset(
                  snapshot.data?.data.vehicleType == 'Car'
                      ? 'assets/images/camry2.png'
                      : 'assets/images/van2.png',
                  width: MediaQuery.of(context).size.width / 2,
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                Center(
                  child: DataTable(
                    columnSpacing: 5,
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
                              snapshot.data?.data.vehicleType.toString() ?? "",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .03,
                                  fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('company_name'.tr)),
                          DataCell(
                              Text(snapshot.data?.data.name.toString() ?? "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('project_name'.tr)),
                          DataCell(Text(
                              snapshot.data?.data.projectName.toString() ??
                                  "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('number_of_trips'.tr)),
                          DataCell(Text(
                              snapshot.data?.data.dateArray.length.toString() ??
                                  "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('total_price_2'.tr)),
                          DataCell(Text(
                              '${snapshot.data!.data.totalPrice} ${snapshot.data!.currency}'))
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('service'.tr)),
                          DataCell(Text(
                              snapshot.data?.data.service.toString() ?? "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('status'.tr)),
                          DataCell(Text(
                              snapshot.data?.data.status.toString() ?? "")),
                        ],
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.data.destinationArray.length,
                    itemBuilder: (context, i) {
                      var data = snapshot.data!.data;
                      return ListTile(
                        title: Text(data.destinationArray[i]),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(data.dateArray[i]),
                                Text(data.timeArray[i]),
                                Text(data.locationArray[i] ==
                                        'Multi Location Way'
                                    ? ''
                                    : data.locationArray[i]),
                              ],
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: secondaryColor1,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }),
              ],
            );
          }),
    );
  }
}
