import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/api/method_api.dart';
import 'package:lyon/model/is_car_available_model.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/Widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/mehod/switch_sreen.dart';
import 'confirm.dart';

class DetailsCar extends StatefulWidget {
  final int? price;
  final String firstDate;
  final String lastDate;
  final String carId;
  final String? carImage;
  final String firstTime;
  final String endTime;

  const DetailsCar(
      {super.key,
      required this.price,
      required this.firstDate,
      required this.carId,
      required this.lastDate,
      required this.firstTime,
      required this.endTime,
      this.carImage});

  @override
  // ignore: library_private_types_in_public_api
  _DetailsCarState createState() => _DetailsCarState();
}

class _DetailsCarState extends State<DetailsCar> {
  TextEditingController firstDateController = TextEditingController();
  TextEditingController firstTimeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime? selectedDate;
  DateTime? firstDate;
  DateTime? lastDate;
  DateTime? firstController;
  DateTime? secondController;
  bool isDateNull = true;
  bool isEndDateNull = false;

  Future<void> _selectDateFirst(
      {required BuildContext context,
      required TextEditingController dateController,
      selectedDate,
      firstDate,
      lastDate}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: DateTime((DateTime.now().year) + 3, 12),
        errorInvalidText: "Out of range");
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        firstController = picked;

        dateController.text =
            "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
      });
    }
  }

  Future<void> _selectDateSecond(
      {required BuildContext context,
      required TextEditingController dateController,
      selectedDate,
      firstDate,
      lastDate}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        currentDate: selectedDate,
        lastDate: selectedDate.add(const Duration(days: 35)),
        errorInvalidText: "Out of range");
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        secondController = selectedDate;
        dateController.text =
            "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
      });
    }
  }

  late String time;

  Future<void> _selectTimeFirst(
      {required BuildContext context,
      required TextEditingController timeController}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      // ignore: use_build_context_synchronously
      time = pickedTime.format(context);
      DateTime parsedTime =
          // ignore: use_build_context_synchronously
          DateFormat.Hm().parse(pickedTime.format(context).toString());
      // ignore: use_build_context_synchronously
      if (pickedTime.format(context).toString().contains("AM")) {
        parsedTime = parsedTime.hour == 12
            ? parsedTime.subtract(const Duration(hours: 12))
            : parsedTime;
      }
      // ignore: use_build_context_synchronously
      if (pickedTime.format(context).toString().contains("PM")) {
        parsedTime = parsedTime.hour == 12
            ? parsedTime
            : parsedTime.add(const Duration(hours: 12));
      }
      String formattedTime = DateFormat.Hms().format(parsedTime);
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  Future<void> _selectTimeSecond(
      {required BuildContext context,
      required TextEditingController timeController}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      // ignore: use_build_context_synchronously
      time = pickedTime.format(context);
      DateTime parsedTime =
          // ignore: use_build_context_synchronously
          DateFormat.Hm().parse(pickedTime.format(context).toString());
      // ignore: use_build_context_synchronously
      if (pickedTime.format(context).toString().contains("AM")) {
        parsedTime = parsedTime.hour == 12
            ? parsedTime.subtract(const Duration(hours: 12))
            : parsedTime;
      }
      // ignore: use_build_context_synchronously
      if (pickedTime.format(context).toString().contains("PM")) {
        parsedTime = parsedTime.hour == 12
            ? parsedTime
            : parsedTime.add(const Duration(hours: 12));
      }
      String formattedTime = DateFormat.Hms().format(parsedTime);
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  getDataSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', 1);
  }

  List<String> carImage = [];
  List<String> internalSpecifications = [];
  String typeCAR = '';
  List<String> features = [];
  bool descTextShowFlag = false;
  List<String> safetyFeatures = [];
  var concatenateinternal = StringBuffer();
  var concatenatefeatures = StringBuffer();
  var concatenatesafetyFeatures = StringBuffer();
  @override
  void initState() {
    items[0] = 'amman'.tr;
    items[1] = 'king_hussien_bridge'.tr;
    items[2] = 'queen_alia_airport'.tr;
    if (kDebugMode) {
      print(items);
    }
    getDataSharedPreferences();
    MethodAppApi().methodPOSTReturnResponse(
        url: ApiApp.getCarDetails,
        body: {"id": widget.carId, "mobile": "1"}).then((value) {
      int length = value["imageCount"];
      int internalCount = value["internalCount"];
      int specCount = value["specCount"];
      int safetyCount = value["safetyCount"];
      typeCAR = value["data"]["name"];
      for (int i = 0; i < length; i++) {
        // ignore: prefer_interpolation_to_compose_strings
        carImage.add('https://lyon-jo.com/' + value["data"]["images"][i]);
      }

      for (int i = 0; i < safetyCount; i++) {
        safetyFeatures.add(value["data"]["Safety Features"][i]);
      }
      for (int i = 0; i < specCount; i++) {
        features.add(value["data"]["Features"][i]);
      }
      for (int i = 0; i < internalCount; i++) {
        internalSpecifications.add(value["data"]["Internal Specifications"][i]);
      }
      setState(() {
        showCircle = false;
        for (var item in internalSpecifications) {
          concatenateinternal.write('\u{2714} $item\n');
        }
        for (var item in features) {
          concatenatefeatures.write('\u{2714} $item\n');
        }
        for (var item in safetyFeatures) {
          concatenatesafetyFeatures.write('\u{2714} $item\n');
        }
      });
    });

    setState(() {
      firstDateController.text = widget.firstDate;
    });
    setState(() {
      endDateController.text = widget.lastDate;
    });
      super.initState();
  }

  @override
  void dispose() {
    dropDownValueStart = '';
    dropDownValueEnd = '';
    checkStart = false;
    checkEnd = false;
    super.dispose();
  }

  // ignore: unused_element
  _fetchPost() async {
    try {
      await fetchIsCarAvailable();
    } finally {}
  }

  bool showCircle = true;
  final _formKey = GlobalKey<FormState>();
  bool isLoadingButton = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBarWithNotification(
        text: "details".tr,
        context: context,
        withIcon: true,
        canBack: true,
        doubleBack: true,
      ),
      body: showCircle
          ? const Center(child: CircularProgressIndicator())
          : isLoadingButton
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * .01,
                        ),
                        Text(
                          typeCAR,
                          style: styleBlack25WithBold,
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        SizedBox(
                          height: height / 5,
                          width: width,
                          child: CarouselSlider.builder(
                            unlimitedMode: true,
                            autoSliderDelay: const Duration(seconds: 3),
                            keepPage: true,
                            enableAutoSlider: true,
                            slideTransform: const DefaultTransform(),
                            autoSliderTransitionTime:
                                const Duration(seconds: 2),
                            itemCount: carImage.length,
                            slideBuilder: (index) => Image.network(
                              carImage[index],
                              width: double.infinity,
                              height: height / 5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child:
                                  textFieldWidgetWithoutFilledWithFunctionSmall(
                                context: context,
                                fun: () {
                                  _selectDateFirst(
                                    context: context,
                                    dateController: firstDateController,
                                    selectedDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime((DateTime.now().year) + 3, 12),
                                  );
                                  setState(() {
                                    endDateController.text = '';
                                    isDateNull = false;
                                  });
                                },
                                icons: const Icon(Icons.calendar_today),
                                controller: firstDateController,
                                hintText: widget.firstDate,
                              ),
                            ),
                            SizedBox(
                              width: width * .01,
                            ),
                            Expanded(
                              flex: 2,
                              child:
                                  textFieldWidgetWithoutFilledWithFunctionSmall(
                                context: context,
                                fun: () {
                                  _selectTimeFirst(
                                      context: context,
                                      timeController: firstTimeController);
                                },
                                icons: const Icon(Icons.access_time),
                                controller: firstTimeController,
                                hintText: widget.firstTime,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child:
                                  textFieldWidgetWithoutFilledWithFunctionSmall(
                                context: context,
                                fun: firstController == null
                                    ? () {}
                                    : () {
                                        setState(() {
                                          isEndDateNull = false;
                                        });
                                        _selectDateSecond(
                                          context: context,
                                          dateController: endDateController,
                                          firstDate: DateTime.now(),
                                          selectedDate: firstController,
                                          lastDate: firstController!
                                              .add(const Duration(days: 35)),
                                        );
                                      },
                                icons: const Icon(Icons.calendar_today),
                                controller: endDateController,
                                hintText: widget.lastDate,
                              ),
                            ),
                            SizedBox(
                              width: width * .02,
                            ),
                            Expanded(
                              flex: 2,
                              child:
                                  textFieldWidgetWithoutFilledWithFunctionSmall(
                                context: context,
                                fun: () {
                                  _selectTimeSecond(
                                      context: context,
                                      timeController: endTimeController);
                                },
                                icons: const Icon(Icons.access_time),
                                controller: endTimeController,
                                hintText: widget.endTime,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                            visible: isEndDateNull,
                            child: Padding(
                              padding: EdgeInsets.only(top: height * .01),
                              child: Text(
                                'please_enter_end_date'.tr,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            )),
                        SizedBox(
                          height: height * .01,
                        ),
                        const Divider(
                          color: Colors.black,
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              maxLines: descTextShowFlag ? 60 : 6,
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                text: '',
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '${'internal_specifications'.tr}\n\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          '${concatenateinternal.toString()}\n'),
                                  TextSpan(
                                      text: '${'features'.tr}\n\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          '${concatenatefeatures.toString()}\n'),
                                  TextSpan(
                                      text: '${'safety_features'.tr}\n\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          concatenatesafetyFeatures.toString()),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  descTextShowFlag = !descTextShowFlag;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  descTextShowFlag
                                      ? Text(
                                          "show_less".tr,
                                          style: const TextStyle(
                                              color: secondaryColor1),
                                        )
                                      : Text("show_more".tr,
                                          style: const TextStyle(
                                              color: secondaryColor1))
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                          height: 16,
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Center(
                            child: Text(
                          "determine_start_and_end_location".tr,
                          style: stylePrimary18,
                        )),
                        SizedBox(
                          height: height * .015,
                        ),
                        Form(
                          key: _formKey,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                    dropdownColor: Colors.white,
                                    hint: Text("start_location".tr),
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items,
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        dropDownValueStart = newValue!;
                                        checkStart = false;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: height * .01,
                                ),
                                checkStart
                                    ? Text(
                                        "please_enter_this_field_start_location"
                                            .tr,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    : const Text(""),
                                SizedBox(
                                  height: height * .01,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButtonFormField<String>(
                                    dropdownColor: Colors.white,
                                    hint: Text("end_location".tr),
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items,
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        dropDownValueEnd = newValue!;
                                        checkEnd = false;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: height * .01,
                                ),
                                checkEnd
                                    ? Text(
                                        "please_enter_this_field_end_location"
                                            .tr,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    : const Text(""),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .01,
                        ),
                        Center(
                            child: SizedBox(
                          width: width / 2,
                          height: height * .05,
                          child: buttonSmall(
                              context: context,
                              text: "book".tr,
                              function: () async {
                                if (firstDateController.text.isNotEmpty &&
                                    endDateController.text.isEmpty) {
                                  setState(() {
                                    isEndDateNull = true;
                                  });
                                } else {
                                  if (_formKey.currentState!.validate() &&
                                      dropDownValueStart != '' &&
                                      dropDownValueEnd != '') {
                                    setState(() {
                                      checkStart = false;
                                      checkEnd = false;
                                      isLoadingButton = true;
                                    });
                                    IsCarAvailable? isCarAvailable =
                                        await fetchIsCarAvailable();

                                    if (isCarAvailable!.status == 200) {
                                      push(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          ConfirmInformation(
                                            carId: widget.carId,
                                            typeCar: typeCAR,
                                            startDate:
                                                firstDateController.text == ''
                                                    ? widget.firstDate
                                                    : firstDateController.text,
                                            startTime:
                                                firstTimeController.text == ''
                                                    ? widget.firstTime
                                                    : firstTimeController.text,
                                            returnDate:
                                                endDateController.text == ''
                                                    ? widget.lastDate
                                                    : endDateController.text,
                                            returnTime:
                                                endTimeController.text == ''
                                                    ? widget.endTime
                                                    : endTimeController.text,
                                            firstLocation: dropDownValueStart,
                                            endLocation: dropDownValueEnd,
                                            numberOfDay: isCarAvailable.days,
                                            numberOfHour: 0,
                                            currency: isCarAvailable.currency!,
                                            totalPrice: isCarAvailable.price!,
                                            pricePerDay:
                                                isCarAvailable.pricePerDay,
                                            carImage: widget.carImage,
                                            gasoline: isCarAvailable.gasoline!,
                                            carSeat: isCarAvailable.carSeat!,
                                            insurance:
                                                isCarAvailable.insurance!,
                                            smokingCar:
                                                isCarAvailable.smokingCar!,
                                            ashtray: isCarAvailable.ashtray!,
                                          ));
                                      setState(() {
                                        isLoadingButton = false;
                                        dropDownValueStart = '';
                                        dropDownValueEnd = '';
                                      });
                                    } else {
                                      showDialog(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("message".tr),
                                            content: Text(
                                              isCarAvailable.message.toString(),
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                            actions: <Widget>[
                                              // ignore: deprecated_member_use
                                              TextButton(
                                                child: Text("ok".tr),
                                                onPressed: () {
                                                  setState(() {
                                                    dropDownValueStart = '';
                                                    dropDownValueEnd = '';
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      setState(() {
                                        isLoadingButton = false;
                                      });
                                    }
                                  } else {
                                    if (dropDownValueStart == "" &&
                                        dropDownValueEnd == "") {
                                      setState(() {
                                        checkStart = true;
                                        checkEnd = true;
                                        isLoadingButton = false;
                                      });
                                    } else if (dropDownValueStart == "") {
                                      setState(() {
                                        checkStart = true;
                                      });
                                    } else if (dropDownValueEnd == "") {
                                      setState(() {
                                        checkEnd = true;
                                      });
                                    }
                                  }
                                }
                              }),
                        )),
                        SizedBox(
                          height: height * .02,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future<IsCarAvailable?> fetchIsCarAvailable() async {
    String apiUrl = ApiApp.isAvaliableCars;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');

    String changeDate(String date) {
      var year = date.split('/')[0];
      var month = int.parse(date.split('/')[1]);
      var day = int.parse(date.split('/')[2]);
      return ("$year-${month <= 9 ? "0$month" : month}-${day <= 9 ? "0$day" : day}")
          .toString();
    }

    final json = {
      "startDate": firstDateController.text == ''
          ? changeDate(widget.firstDate)
          : changeDate(firstDateController.text),
      "startTime": firstTimeController.text == ''
          ? widget.firstTime
          : firstTimeController.text,
      "endDate": endDateController.text == ''
          ? changeDate(widget.lastDate)
          : changeDate(endDateController.text),
      "endTime": endTimeController.text == ''
          ? widget.endTime
          : endTimeController.text,
      "id": widget.carId,
      "mobile": "1",
      "token": sharedToken,
    };
    if (kDebugMode) {
      print("this is my majd$json");
    }
    http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: json,
    );
    if (kDebugMode) {
      print(response.statusCode);
    }
    if (kDebugMode) {
      print(response.body);
    }
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse["status"] == 422 || jsonResponse["status"] == 400) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: Text(
              jsonResponse["message"],
              style: const TextStyle(color: Colors.red),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              TextButton(
                child: Text("ok".tr),
                onPressed: () {
                  setState(() {
                    dropDownValueStart = '';
                    dropDownValueEnd = '';
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    if (jsonResponse["status"] == 200) {
      var x = IsCarAvailable.fromJson(jsonResponse);
      return x;
    }
    return null;
  }
}

bool checkStart = false;
bool checkEnd = false;
List<String> items = [
  'amman'.tr,
  'king_hussien_bridge'.tr,
  'queen_alia_airport'.tr
];
String dropDownValueStart = "";
String dropDownValueEnd = "";

Widget internalData(
    {required Widget icon, required String description, required String type}) {
  return Column(
    children: [
      Text(
        type,
        style: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        description,
        style: const TextStyle(color: Colors.blue, fontSize: 10),
      ),
      const SizedBox(
        height: 5,
      ),
      icon
    ],
  );
}
