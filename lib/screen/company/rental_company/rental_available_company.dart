import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lyon/model/company_model/available_car_company_model.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api.dart';
import '../../../shared/styles/colors.dart';
import 'rental_checkout_company.dart';

class RentalAvailableCompany extends StatefulWidget {
  const RentalAvailableCompany({super.key});

  @override
  State<RentalAvailableCompany> createState() => _RentalAvailableCompanyState();
}

class _RentalAvailableCompanyState extends State<RentalAvailableCompany> {
  late Future<AvailableCarCompanyModel> futurePost;

  Future<AvailableCarCompanyModel> getCarsCompany() async {
    String apiUrl = ApiApp.getCompanyVehicles;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token_company');
    final json = {"token": sharedToken, "mobile": "1"};

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);

    var jsonResponse = jsonDecode(response.body);
    return AvailableCarCompanyModel.fromJson(jsonResponse);
  }

  @override
  void initState() {
    futurePost = getCarsCompany();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: secondaryColor1,
            title: Text('car available'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 25))),
        body: FutureBuilder<AvailableCarCompanyModel>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.6,
                      mainAxisExtent: 340,
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 2 : 3),
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        push(
                            context,
                            RentalCheckOutCompany(
                                vehicleName:
                                    snapshot.data!.data![i].vehicle.toString(),
                                id: snapshot.data!.data![i].id.toString(),
                                carId: snapshot.data!.data![i].carId.toString(),
                                carImage:
                                    'https://lyon-jo.com/${snapshot.data!.data![i].thumbnail}'));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                flex: 1,
                                child: Text(snapshot.data!.data![i].vehicle
                                    .toString())),
                            Flexible(
                              flex: 3,
                              child: Image.network(
                                  'https://lyon-jo.com/${snapshot.data!.data![i].thumbnail}'
                                  // carsImage[i].toString(),
                                  // height: MediaQuery.of(context).size.height,
                                  // width: MediaQuery.of(context).size.width*.1,
                                  ),
                            ),
                            Text('similar'.tr),
                            Flexible(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${snapshot.data!.data![i].monthlyPrice!.toStringAsFixed(0)} ${snapshot.data!.currency}',
                                      style: TextStyle(
                                        color: colorPrimary,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                .05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Center(child: Text('Per_day_Month'.tr)),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5),
                                  color: secondaryColor1),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: Text(
                                    'book'.tr,
                                    style: const TextStyle(
                                        color: secondaryColor, fontSize: 20),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
