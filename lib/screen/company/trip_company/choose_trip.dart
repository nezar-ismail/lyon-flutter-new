import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lyon/v_done/trip_form/views/selecte_multe_trip_company.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';

// import '../shared/styles/colors.dart';

class ChooseTrip extends StatefulWidget {
  const ChooseTrip({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChooseTripState createState() => _ChooseTripState();
}

bool isNumberOfTripsEnterd = false;

class _ChooseTripState extends State<ChooseTrip> {
  TextEditingController numberTrip = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor1,
        title: Text(
          'trip'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {
                  push(
                      context,
                      SelecteMulteTripCompany(
                        type: "Car",
                      ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset('assets/images/camry2.png',
                        // width: 300,
                        height: height / 4,
                        fit: BoxFit.fitHeight),
                    ListTile(
                      title: Text(
                        'car'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '${'1_4_people'.tr}\n${'capacity_3_luggage'.tr}',
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {
                  push(
                      context,
                      SelecteMulteTripCompany(
                        type: "Van",
                      ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset('assets/images/van2.png',
                        // width: 300,
                        height: height / 4,
                        fit: BoxFit.fitHeight),
                    ListTile(
                      title: Text(
                        'van'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '${'5_7_people'.tr}\n${'capacity_10_luggage'.tr}',
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('please_choose_vehicle'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
