import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:lyon/shared/Widgets/appbar.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/styles/colors.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen(
      {super.key,
      required this.fromLocation,
      required this.toLocation,
      required this.date,
      required this.time,
      required this.carType,
      required this.price,
      required this.tripType,
      required this.currency});
  final String fromLocation;
  final String toLocation;
  final String date;
  final String time;
  final String carType;
  final String price;
  final String tripType;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars(
          withIcon: false,
          text: 'Confirmation',
          context: context,
          canBack: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(
                    child: Image.asset(
                  carType == 'Car'
                      ? 'assets/images/camry2.png'
                      : 'assets/images/van2.png',
                  width: 250,
                )),
                const SizedBox(height: 20),
                toLocation == ''
                    ? CustomText(
                        text: fromLocation,
                        alignment: Alignment.center,
                        color: secondaryColor1,
                        fontWeight: FontWeight.bold,
                        size: 20,
                      )
                    : CustomText(
                        text: '$fromLocation - $toLocation',
                        alignment: Alignment.center,
                        color: secondaryColor1,
                        fontWeight: FontWeight.bold,
                        size: 20,
                      ),
                const SizedBox(height: 20),
                Center(
                    child: CustomText(
                  text: '$date - $time',
                  color: secondaryColor1,
                  size: 20,
                  fontWeight: FontWeight.bold,
                  alignment: Alignment.center,
                )),
                const SizedBox(height: 20),
                GFListTile(
                    titleText: 'Price',
                    subTitleText:
                        '${double.parse(price).roundToDouble()} $currency', // ignore: prefer_single_quotes

                    icon: const Icon(Icons.money)),
                const SizedBox(height: 20),
                GFListTile(
                    titleText: 'Car Type',
                    subTitleText: carType, // ignore: prefer_single_quotes
                    icon: const Icon(Icons.car_rental)),
                const SizedBox(height: 20),
                GFListTile(
                    titleText: 'Trip Type',
                    subTitleText: tripType, // ignore: prefer_single_quotes
                    icon: const Icon(Icons.trip_origin)),
                const SizedBox(height: 20),
                SizedBox(

                    // ignore: deprecated_member_use
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'confirm'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                ))
              ],
            ),
          ),
        ));
  }
}
