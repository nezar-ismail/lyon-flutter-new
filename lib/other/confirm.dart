import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/check_out_controller.dart/check_out_controller.dart';
import 'package:lyon/other/new_check_out.dart';
import 'package:lyon/other/payment_page_rental.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/Widgets/divder.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import '../shared/Widgets/appbar.dart';
//import 'check_out.dart';

// ignore: must_be_immutable
class ConfirmInformation extends StatefulWidget {
  final String typeCar;
  final String startDate;
  final String startTime;
  final String returnDate;
  final String returnTime;
  final String? carImage;
  final String firstLocation;
  final String endLocation;
  final int? numberOfDay;
  final int numberOfHour;
  final int? pricePerDay;
  final String carId;
  int totalPrice;
  final String currency;
  int gasoline;
  int carSeat;
  int smokingCar;
  int ashtray;
  int insurance;

  ConfirmInformation(
      {super.key,
      required this.typeCar,
      required this.startDate,
      required this.startTime,
      required this.returnDate,
      required this.returnTime,
      required this.firstLocation,
      required this.endLocation,
      required this.numberOfDay,
      required this.numberOfHour,
      this.pricePerDay,
      required this.totalPrice,
      this.carImage,
      required this.carId,
      required this.currency,
      required this.gasoline,
      required this.ashtray,
      required this.smokingCar,
      required this.carSeat,
      required this.insurance});

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmInformationState createState() => _ConfirmInformationState();
}

class _ConfirmInformationState extends State<ConfirmInformation> {
  int priceExtra = 0;
  int total = 0;
  int totalPrice = 0;
  int pricePerDay = 0;
  int extraOption = 0;

  int numberOfDays = 0;
  late double tax;
  late int numberOfHours;
  int gasoline = 20;
  int carSeat = 2;
  int smokingCar = 0;
  int ashtray = 0;
  int insurance = 10;

  @override
  void initState() {
    setState(() {
      gasoline = widget.gasoline;
      carSeat = widget.carSeat;
      smokingCar = widget.smokingCar;
      ashtray = widget.ashtray;
      insurance = widget.insurance;
      numberOfDays = widget.numberOfDay!;
      totalPrice = widget.totalPrice;
      total = totalPrice;
      pricePerDay = widget.pricePerDay!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<int> price = [
      widget.gasoline,
      widget.carSeat,
      widget.smokingCar,
      widget.ashtray,
      widget.insurance
    ];
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    CheckOutController checkOutController = Get.find<CheckOutController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithNotification(
        text: "confirm".tr,
        context: context,
        withIcon: true,
        canBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.network(
                widget.carImage.toString(),
                fit: BoxFit.contain,
                width: width / 2,
              )),
              SizedBox(
                height: height * .02,
              ),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: width * .03,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    columns: [
                      DataColumn(
                          label: Text('type'.tr,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text(widget.typeCar.toString(),
                              style: TextStyle(
                                  fontSize: width * .03,
                                  fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('start_date'.tr)),
                        DataCell(Text(widget.startDate.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('start_time'.tr)),
                        DataCell(Text(widget.startTime.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('return_date'.tr)),
                        DataCell(Text(widget.returnDate.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('return_time'.tr)),
                        DataCell(Text(widget.returnTime.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('pick_up_location'.tr)),
                        DataCell(Text(widget.firstLocation.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('drop_off_location'.tr)),
                        DataCell(Text(widget.endLocation.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('number_of_days'.tr)),
                        DataCell(Text('${widget.numberOfDay}')),
                      ]),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .02,
              ),
              Container(
                // height: MediaQuery.of(context).size.height * .3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "select_extra_item".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          // style: styleSecondary20,
                        ),
                      ),
                      //  dividerHorizontal(context: context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .001,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .34,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: item.length,
                          itemBuilder: (BuildContext context, int index) {
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                    void Function(void Function()) setState) {
                              return Column(children: [
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 9,
                                        child: Text(
                                          item[index],
                                          style: const TextStyle(fontSize: 18),
                                        )),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "${price[index]}  ${widget.currency}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Checkbox(
                                        value: isCheckedList2[index],
                                        onChanged: (val) {
                                          setState(() {
                                            isCheckedList2[index] = val!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .001,
                                ),
                                dividerHorizontal(context: context),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .001,
                                ),
                              ]);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              // height: _height * .01,
              // ),
              Center(
                  child: button(
                      context: context,
                      text: "confirm".tr,
                      color: Colors.white,
                      function: () async {
                        setState(() {
                          for (var i = 0; i < isCheckedList.length; i++) {
                            if (isCheckedList2[i] == true) {
                              if (isCheckedList[i] == false) {
                                if (i == 1 || i == 4) {
                                  extraOption =
                                      (extraOption + (price[i] * numberOfDays));
                                } else {
                                  extraOption = (extraOption + price[i]);
                                }
                              }
                            }

                            if (isCheckedList[i] == true &&
                                isCheckedList2[i] == false) {
                              if (i == 1 || i == 4) {
                                extraOption =
                                    (extraOption - (price[i] * numberOfDays));
                              } else {
                                extraOption = (extraOption - price[i]);
                              }
                            }
                          }
                          for (var i = 0; i < isCheckedList2.length; i++) {
                            isCheckedList[i] = isCheckedList2[i];
                          }
                          totalPrice = widget.totalPrice + extraOption;
                          //  = totalPrice;
                        });

                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                backgroundColor: Colors.grey.shade300,
                                title: Text(
                                  "summary".tr,
                                  style: stylePrimary25ithBold,
                                ),
                                content: SizedBox(
                                  width: width * .80,
                                  height: height * .3,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${'car_price_day'.tr}${widget.pricePerDay}  ${widget.currency}',
                                          style: stylePrimary20,
                                        ),
                                        dividerHorizontal(context: context),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        Text(
                                          "${"total_car_price".tr}${(widget.totalPrice / 1.16).toStringAsFixed(2)}  ${widget.currency}",
                                          style: stylePrimary20,
                                        ),
                                        dividerHorizontal(context: context),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        Text(
                                          "${"extra_items".tr}$extraOption ${widget.currency}",
                                          style: stylePrimary20,
                                        ),
                                        dividerHorizontal(context: context),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        Text(
                                          "tax".tr,
                                          style: stylePrimary20,
                                        ),
                                        dividerHorizontal(context: context),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        Text(
                                          "${"total".tr}${(widget.totalPrice + extraOption).toStringAsFixed(2)}  ${widget.currency}",
                                          style: stylePrimary20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  // ignore: deprecated_member_use
                                  TextButton(
                                    child: Text("ok".tr),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeCap: StrokeCap.square,
                                                strokeWidth: 5,
                                              ),
                                            );
                                          });
                                      await checkOutController
                                          .checkIfLicenseAndPassportAreAttached();
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();

                                      showDialog(
                                          barrierDismissible: false,
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          builder: (BuildContext context) {
                                            isChecked = false;
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return Obx(() => AlertDialog(
                                                  backgroundColor:
                                                      Colors.grey.shade300,
                                                  title: Text(
                                                      "terms_and_conditions"
                                                          .tr),
                                                  content: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      children: [
                                                        Text(
                                                            '\u2022 ${'term1'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term2'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term3'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term5'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term5_1_1'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term5_1_2'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term5_1_3'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term5_2'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term5_2_1'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term6'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term7'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term8'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term9_1'.tr}\n    -	${'term9_2'.tr}\n    -	${'term9_3'.tr}\n    -	${'term9_4'.tr}\n\n${'term9_5'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term10'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term11'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term12_1'.tr}\n\n    -	${'term12_2'.tr}\n\n    -	${'term12_2_1'.tr}\n\n    -	${'term12_3'.tr}\n\n        -	${'term12_5_2'.tr}\n\n    -	${'term12_5_3'.tr}\n\n    -	${'term12_5_4'.tr}\n\n    -	${'term12_5_5'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term12_6'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term14_1'.tr}\n${'term14_2'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term15'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term15_1'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term15_2'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term16_1'.tr}\n    -	${'term16_2'.tr}\n    -	${'term16_3'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term17'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term18'.tr}\n'),
                                                        Text(
                                                            '\u2022 ${'term19'.tr}\n\n    -	${'term19_1'.tr}\n\n    -	${'term19_2'.tr}\n'),
                                                        CheckboxListTile(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          title: Text(
                                                              'i_read_and_agree'
                                                                  .tr),
                                                          value: isChecked,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              isChecked =
                                                                  value!;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions:
                                                      (widget.firstLocation
                                                                          .trim() ==
                                                                      "Queen Alia Airport" ||
                                                                  widget.firstLocation
                                                                          .trim() ==
                                                                      "مطار الملكه علياء" ||
                                                                  widget.firstLocation ==
                                                                      "Queen Alia Airport" ||
                                                                  widget.endLocation
                                                                          .trim() ==
                                                                      "Queen Alia Airport" ||
                                                                  widget.endLocation
                                                                          .trim() ==
                                                                      "مطار الملكه علياء" ||
                                                                  widget.endLocation
                                                                          .trim() ==
                                                                      "Queen Alia Airport") &&
                                                              checkOutController
                                                                  .justDoneToSolveTheError
                                                                  .value
                                                          ? <Widget>[
                                                              isChecked == false
                                                                  ? const TextButton(
                                                                      onPressed:
                                                                          null,
                                                                      child: Text(
                                                                          'ok'),
                                                                    )
                                                                  : TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        // push(
                                                                        //     context,
                                                                        //     CheckOut(
                                                                        //         isCheckedList: isCheckedList,
                                                                        //         totalPrice: totalPrice.toStringAsFixed(2),
                                                                        //         startDate: widget.startDate,
                                                                        //         endDate: widget.returnDate,
                                                                        //         startTime: widget.startTime,
                                                                        //         endTime: widget.returnTime,
                                                                        //         startLocation: widget.firstLocation,
                                                                        //         endLocation: widget.endLocation,
                                                                        //         carId: widget.carId,
                                                                        //         pricePerDay: widget.pricePerDay,
                                                                        //         currency: widget.currency));
                                                                        push(
                                                                            context,
                                                                            NewCheckOut(
                                                                              pickUpSpot: widget.firstLocation,
                                                                              destinationSpot: widget.endLocation,
                                                                              totalPrice: totalPrice.toStringAsFixed(2),
                                                                              startDate: widget.startDate,
                                                                              startTime: widget.startTime,
                                                                              endDate: widget.returnDate,
                                                                              endTime: widget.returnTime,
                                                                              isCheckedList: isCheckedList,
                                                                              carId: widget.carId,
                                                                              pricePerDay: pricePerDay,
                                                                              currency: widget.currency,
                                                                              inOurOutside: "Jordan",
                                                                            ));
                                                                      },
                                                                      child: const Text(
                                                                          "ok")),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      "Cancel"))
                                                            ]
                                                          : checkOutController
                                                                  .licenseAndPassportAreAttached
                                                                  .value
                                                              ? <Widget>[
                                                                  isChecked ==
                                                                          false
                                                                      ? const TextButton(
                                                                          onPressed:
                                                                              null,
                                                                          child:
                                                                              Text('ok'),
                                                                        )
                                                                      : TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            //isCheckUploadImage = false; | This variable is there in the check_out.dart - file.
                                                                            // checkOutController.jumpToPaymentMethodPage.value ?
                                                                            push(context,
                                                                                CashOrVisa(totalPrice: totalPrice.toString(), startDate: widget.startDate, startTime: widget.startTime, endDate: widget.returnDate, endTime: widget.returnTime, startLocation: widget.firstLocation, endLocation: widget.endLocation, isCheckedList: isCheckedList, carId: widget.carId, pricePerDay: pricePerDay, currency: widget.currency, inOrOutSide: "Jordan"));
                                                                            // push(
                                                                            //     context,
                                                                            //     CheckOut(
                                                                            //         isCheckedList: isCheckedList,
                                                                            //         totalPrice: totalPrice.toStringAsFixed(2),
                                                                            //         startDate: widget.startDate,
                                                                            //         endDate: widget.returnDate,
                                                                            //         startTime: widget.startTime,
                                                                            //         endTime: widget.returnTime,
                                                                            //         startLocation: widget.firstLocation,
                                                                            //         endLocation: widget.endLocation,
                                                                            //         carId: widget.carId,
                                                                            //         pricePerDay: widget.pricePerDay,
                                                                            //         currency: widget.currency));
                                                                          },
                                                                          child:
                                                                              const Text("ok")),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: const Text(
                                                                        "cancel"),
                                                                  )
                                                                ]
                                                              : <Widget>[
                                                                  isChecked ==
                                                                          false
                                                                      ? const TextButton(
                                                                          onPressed:
                                                                              null,
                                                                          child:
                                                                              Text('ok'),
                                                                        )
                                                                      : TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            // push(
                                                                            //     context,
                                                                            //     CheckOut(
                                                                            //         isCheckedList: isCheckedList,
                                                                            //         totalPrice: totalPrice.toStringAsFixed(2),
                                                                            //         startDate: widget.startDate,
                                                                            //         endDate: widget.returnDate,
                                                                            //         startTime: widget.startTime,
                                                                            //         endTime: widget.returnTime,
                                                                            //         startLocation: widget.firstLocation,
                                                                            //         endLocation: widget.endLocation,
                                                                            //         carId: widget.carId,
                                                                            //         pricePerDay: widget.pricePerDay,
                                                                            //         currency: widget.currency));
                                                                            push(context,
                                                                                NewCheckOut(pickUpSpot: widget.firstLocation, destinationSpot: widget.endLocation, totalPrice: totalPrice.toStringAsFixed(2), startDate: widget.startDate, startTime: widget.startTime, endDate: widget.returnDate, endTime: widget.returnTime, isCheckedList: isCheckedList, carId: widget.carId, pricePerDay: pricePerDay, currency: widget.currency, inOurOutside: "Jordan"));
                                                                          },
                                                                          child:
                                                                              const Text("ok")),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          "Cancel"))
                                                                ]));
                                            });
                                          });
                                      // push(
                                      //     context,
                                      //     CheckOut(
                                      //         isCheckedList: isCheckedList,
                                      //         totalPrice:
                                      //             totalPrice.toStringAsFixed(2),
                                      //         startDate: widget.startDate,
                                      //         endDate: widget.returnDate,
                                      //         startTime: widget.startTime,
                                      //         endTime: widget.returnTime,
                                      //         startLocation:
                                      //             widget.firstLocation,
                                      //         endLocation: widget.endLocation,
                                      //         carId: widget.carId,
                                      //         pricePerDay: widget.pricePerDay,
                                      //         currency: widget.currency));
                                    },
                                  ),
                                  // ignore: deprecated_member_use
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
                      })),
              SizedBox(
                height: height * .03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isChecked = true;

  List<bool> isCheckedList = [false, false, false, false, false];
  List<bool> isCheckedList2 = [false, false, false, false, false];
  List<String> item = [
    "filling_of_gasoline".tr,
    "car_seat".tr,
    "non_smoking_car".tr,
    "ashtray".tr,
    "insurance".tr
  ];
}
