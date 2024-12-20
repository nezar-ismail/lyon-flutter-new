import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:lyon/screen/one_dirc_trip.dart';
import 'package:lyon/other/trip_test.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';

import '../shared/Widgets/appbar.dart';
// import '../shared/styles/colors.dart';

class SelectOneTrip extends StatefulWidget {
  const SelectOneTrip({super.key});

  @override
  _SelectOneTripState createState() => _SelectOneTripState();
}

class _SelectOneTripState extends State<SelectOneTrip> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBars(
        text: "trip".tr,
        context: context,
        withIcon: false,
        canBack: true,
        endDrawer: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {
                  push(context,
                      TripTest(image: 'assets/images/camry2.png', type: "Car"));
                  // push(
                  //     context,
                  //     const OneDirctiontrip(
                  //         image: 'assets/images/camry2.png',
                  //         price: 'carPrice',
                  //         type: "Car"));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset('assets/images/camry2.png',
                        // width: 300,
                        height: _height / 4,
                        fit: BoxFit.fitHeight),
                    ListTile(
                      title: Text(
                        'car'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '1_4_people'.tr + '\n' + 'capacity_3_luggage'.tr,
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
                  push(context,
                      TripTest(image: 'assets/images/van2.png', type: "Van"));
                  // push(
                  //     context,
                  //     const OneDirctiontrip(
                  //         image: 'assets/images/van2.png',
                  //         price: 'vanPrice',
                  //         type: "Van"));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset('assets/images/van2.png',
                        // width: 300,
                        height: _height / 4,
                        fit: BoxFit.fitHeight),
                    ListTile(
                      title: Text(
                        'van'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '5_7_people'.tr + '\n' + 'capacity_10_luggage'.tr,
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
            ),
          ],
        ),
      ),
    );
  }
}
