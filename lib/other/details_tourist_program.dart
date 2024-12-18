import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lyon/other/payment_page_tourist_program.dart';
import 'package:lyon/other/user_trip_program/model/trip.dart';
import 'package:lyon/screen/tourism_check_out/tourism_check_out.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/tourism_check_out_controller.dart/tourism_check_out_controller.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import '../shared/Widgets/custom_text.dart';
import '../shared/styles/colors.dart';

class TouristProgramDetails extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final List<UserTrips> trips;
  // ignore: prefer_typing_uninitialized_variables
  final totalPrice;
  // ignore: prefer_typing_uninitialized_variables
  final currency;
  // ignore: prefer_typing_uninitialized_variables
  final image;
  // ignore: prefer_typing_uninitialized_variables
  final vehicleType;
  // ignore: prefer_typing_uninitialized_variables
  final ticket;
  const TouristProgramDetails(
      {super.key,
      required this.trips,
      required this.totalPrice,
      required this.currency,
      required this.ticket,
      required this.image,
      required this.vehicleType});

  @override
  State<TouristProgramDetails> createState() => _TouristProgramDetailsState();
}

class _TouristProgramDetailsState extends State<TouristProgramDetails> {
  bool isLaoding = false;
  bool isVisibleTicket = false;
  bool isCheckTicket = false;
  String locationTicket = '';
  bool isLoading = false;
  int counter = 0;

  @override
  void initState() {
    logWarning('details trip page :${widget.trips}');
    counter = 0;
    super.initState();
    isVisibleTicket = widget.ticket;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    // GetStorage().write('keyIsFirstLoaded', false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    TourismCheckOutController tourismCheckOutController = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor1,
        centerTitle: true,
        title: Text(
          "details".tr,
        ),
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : ListView(
              children: [
                SizedBox(
                  height: height * .03,
                ),
                Center(child: Image.asset(widget.image, width: width / 2)),
                SizedBox(
                  height: height * .03,
                ),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.trips.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(widget.trips[i].destination.toString()),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.trips[i].date.toString()),
                            Text(widget.trips[i].time.toString()),
                            Row(
                              children: [
                                Text(widget.trips[i].price.toString()),
                                SizedBox(
                                  width: width * .01,
                                ),
                                Text('${widget.currency}'),
                              ],
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: secondaryColor1,
                          child: Text('${i + 1}'),
                        ),
                      );
                    }),
                SizedBox(
                  height: height * .1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${'total_price_2'.tr} :',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: width * .1,
                      ),
                      Text(
                        '${widget.totalPrice} ${widget.currency}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Align(
                  child: SizedBox(
                      width: width * 0.5,
                      height: height * 0.06,
                      // ignore: deprecated_member_use
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () async {
                          if (counter == 0) {
                            counter++;
                            setState(() {
                              isLaoding = true;
                            });
                            bool passportInserted =
                                await tourismCheckOutController
                                    .checkIfPassportInserted();
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                bool isChecked = false;
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey.shade300,
                                    title: Text("terms_and_conditions".tr),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Text('\u2022 ${'term1_trip'.tr}\n'),
                                          Text('\u2022 ${'term4_trip'.tr}\n'),
                                          Text('\u2022 ${'term5_trip'.tr}\n'),
                                          Text(
                                              '\u2022 ${'term6_trip'.tr}\n\n    -	${'term6_trip_1'.tr}\n    -	${'term6_trip_2'.tr}\n'),
                                          Text('\u2022 ${'term7_trip'.tr}\n'),
                                          Text('\u2022 ${'term8_trip'.tr}\n'),
                                          Text('\u2022 ${'term9_trip'.tr}\n'),
                                          Text('\u2022 ${'term10_trip'.tr}\n'),
                                          Text('\u2022 ${'term11_trip'.tr}\n'),
                                          Text('\u2022 ${'term12_trip'.tr}\n'),
                                          Text('\u2022 ${'term13_trip'.tr}\n'),
                                          Text('\u2022 ${'term14_trip'.tr}\n'),
                                          Text(
                                              '\u2022 ${'term15_trip'.tr}\n\n    -	${'term15_trip_1'.tr}\n    -	${'term15_trip_2'.tr}\n'),
                                          CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text('i_read_and_agree'.tr),
                                            value: isChecked,
                                            onChanged: (value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: widget.ticket
                                        ? <Widget>[
                                            isChecked == false
                                                ? TextButton(
                                                    onPressed: null,
                                                    child: Text('ok'.tr),
                                                  )
                                                : TextButton(
                                                    child: Text("ok".tr),
                                                    onPressed: () {
                                                      push(
                                                          context,
                                                          TourismCheckOut(
                                                              tick:
                                                                  widget.ticket,
                                                              totalPrice: widget
                                                                  .totalPrice
                                                                  .toString(),
                                                              locationTicket:
                                                                  "Outside of Jordan",
                                                              result:
                                                                  widget.trips,
                                                              currency: widget
                                                                  .currency,
                                                              vehicleType: widget
                                                                  .vehicleType));
                                                    },
                                                  ),
                                            TextButton(
                                              child: Text("cancel".tr),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ]
                                        : passportInserted
                                            ? <Widget>[
                                                isChecked == false
                                                    ? TextButton(
                                                        onPressed: null,
                                                        child: Text('ok'.tr),
                                                      )
                                                    : TextButton(
                                                        child: Text("ok".tr),
                                                        onPressed: () {
                                                          push(
                                                              context,
                                                              CashOrVisaTouristProgram(
                                                                  totalPrice: widget
                                                                      .totalPrice
                                                                      .toString(),
                                                                  locationTicket:
                                                                      locationTicket,
                                                                  result: widget
                                                                      .trips,
                                                                  currency: widget
                                                                      .currency,
                                                                  vehicleType:
                                                                      widget
                                                                          .vehicleType));
                                                        },
                                                      ),
                                                TextButton(
                                                  child: Text("cancel".tr),
                                                  onPressed: () {
                                                    counter--;
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ]
                                            : <Widget>[
                                                isChecked == false
                                                    ? TextButton(
                                                        onPressed: null,
                                                        child: Text('ok'.tr),
                                                      )
                                                    : TextButton(
                                                        child: Text("ok".tr),
                                                        onPressed: () {
                                                          push(
                                                              context,
                                                              TourismCheckOut(
                                                                  tick: widget
                                                                      .ticket,
                                                                  totalPrice: widget
                                                                      .totalPrice
                                                                      .toString(),
                                                                  locationTicket:
                                                                      locationTicket,
                                                                  result: widget
                                                                      .trips,
                                                                  currency: widget
                                                                      .currency,
                                                                  vehicleType:
                                                                      widget
                                                                          .vehicleType));
                                                        },
                                                      ),
                                                TextButton(
                                                  child: Text("cancel".tr),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                  );
                                });
                              },
                            );
                          }
                        },
                        child: CustomText(
                          alignment: Alignment.center,
                          text: 'confirm'.tr,
                          color: Colors.white,
                          size: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ],
            ),
    );
  }
}
