import 'dart:convert';

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
  // ignore: prefer_typing_uninitialized_variables
  final firstDate;
  // ignore: prefer_typing_uninitialized_variables
  final lastDate;
  final String carId;
  final String? carImage;
  // ignore: prefer_typing_uninitialized_variables
  final firstTime;
  // ignore: prefer_typing_uninitialized_variables
  final endTime;

  const DetailsCar(
      {super.key,
      required this.price,
      required this.firstDate,
      required this.carId,
      required this.lastDate,
      this.firstTime,
      this.endTime,
      this.carImage});

  @override
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
        // initialFirstDate: new DateTime.now(),
        // initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
        firstDate: firstDate,
        lastDate: DateTime((DateTime.now().year) + 3, 12),
        errorInvalidText: "Out of range");
    // ignore: unnecessary_null_comparison
    if (firstDateController.text == null) {
      // ignore: avoid_returning_null_for_void
      return null;
    }
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
        // initialDatePickerMode: selectedDate,
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
      time = pickedTime.format(context);
      DateTime parsedTime =
          DateFormat.Hm().parse(pickedTime.format(context).toString());
      // ignore: unused_local_variable

      if (pickedTime.format(context).toString().contains("AM")) {
        parsedTime = parsedTime.hour == 12
            ? parsedTime.subtract(const Duration(hours: 12))
            : parsedTime;
      }
      if (pickedTime.format(context).toString().contains("PM")) {
        parsedTime = parsedTime.hour == 12
            ? parsedTime
            : parsedTime.add(const Duration(hours: 12));
      }
      String formattedTime = DateFormat.Hms().format(parsedTime);
      setState(() {
        timeController.text = formattedTime;
        // firstHour = pickedTime.hour;
        // firstMinute = pickedTime.minute;
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
      time = pickedTime.format(context);
      DateTime parsedTime =
          DateFormat.Hm().parse(pickedTime.format(context).toString());
      if (pickedTime.format(context).toString().contains("AM")) {
        parsedTime = parsedTime.hour == 12
            ? parsedTime.subtract(const Duration(hours: 12))
            : parsedTime;
      }
      if (pickedTime.format(context).toString().contains("PM")) {
        parsedTime = parsedTime.hour == 12
            ? parsedTime
            : parsedTime.add(const Duration(hours: 12));
      }
      // ignore: unused_local_variable
      String formattedTime = DateFormat.Hms().format(parsedTime);
      setState(() {
        timeController.text = formattedTime;

        // secondHour = pickedTime.hour;
        // secondMinute = pickedTime.minute;
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
    print(items);
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
        // ignore: avoid_function_literals_in_foreach_calls
        internalSpecifications.forEach((item) {
          concatenateinternal.write('\u{2714} $item\n');
        });
        // ignore: avoid_function_literals_in_foreach_calls
        features.forEach((item) {
          concatenatefeatures.write('\u{2714} $item\n');
        });
        // ignore: avoid_function_literals_in_foreach_calls
        safetyFeatures.forEach((item) {
          concatenatesafetyFeatures.write('\u{2714} $item\n');
        });
      });
    });

    if (widget.firstDate != null) {
      setState(() {
        firstDateController.text = widget.firstDate;
      });
    }
    if (widget.lastDate != null) {
      setState(() {
        endDateController.text = widget.lastDate;
      });
    }
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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
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
                          height: _height * .01,
                        ),
                        Text(
                          typeCAR,
                          style: styleBlack25WithBold,
                        ),
                        SizedBox(
                          height: _height * .02,
                        ),
                        SizedBox(
                          height: _height / 5,
                          width: _width,
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
                              height: _height / 5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * .02,
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
                              width: _width * .01,
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
                          height: _height * .01,
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
                              width: _width * .02,
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
                              padding: EdgeInsets.only(top: _height * .01),
                              child: Text(
                                'please_enter_end_date'.tr,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            )),
                        SizedBox(
                          height: _height * .01,
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
                                          // ignore: unnecessary_string_interpolations
                                          '${concatenatesafetyFeatures.toString()}'),
                                ],
                              ),
                            ),
                            // Text(
                            //     '\n\n \n  \n  \n ',

                            //     textAlign: TextAlign.start),
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [

                        //     dividerVertical(),

                        //     dividerVertical(),

                        //   ],
                        // ),
                        SizedBox(
                          height: _height * .02,
                        ),
                        Center(
                            child: Text(
                          "determine_start_and_end_location".tr,
                          style: stylePrimary18,
                        )),
                        SizedBox(
                          height: _height * .015,
                        ),
                        Form(
                          key: _formKey,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.width/3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  // width: MediaQuery.of(context).size.width,
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
                                  height: _height * .01,
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
                                  height: _height * .01,
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
                                  height: _height * .01,
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
                          height: _height * .01,
                        ),
                        Center(
                            child: SizedBox(
                          width: _width / 2,
                          height: _height * .05,
                          child: buttonSmall(
                              // style: ElevatedButton.styleFrom(
                              //   primary: secondaryColor1,
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(30)),
                              // ),
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
                                    await fetchIsCarAvailable()
                                        .then((value) async {
                                      //Here I am supposed to put the newly created API.
                                      //-----------------------------
                                      // print(sharedToken2);
                                      // Map<String, String> requestBody = {
                                      //   'token': sharedToken2!,
                                      // };

                                      // var response = await http.post(
                                      //   Uri.parse(
                                      //       'https://lyon-jo.com/api/preventMuliableBooking.php'),
                                      //   // headers: {
                                      //   //   'Content-Type':
                                      //   //       "application/json",
                                      //   // },
                                      //   body: requestBody,
                                      // );
                                      // print(response.statusCode);
                                      // if (response.statusCode != 200) {
                                      //   print(
                                      //       "Now I am supposed to display to him a message");
                                      // }

                                      //-----------------------------
                                      if (value.status == 200) {
                                        print("total price: ${value.price}");
                                        push(
                                            context,
                                            ConfirmInformation(
                                              carId: widget.carId,
                                              typeCar: typeCAR,
                                              startDate:
                                                  firstDateController.text == ''
                                                      ? widget.firstDate
                                                      : firstDateController
                                                          .text,
                                              startTime:
                                                  firstTimeController.text == ''
                                                      ? widget.firstTime
                                                      : firstTimeController
                                                          .text,
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
                                              numberOfDay: value.days,
                                              numberOfHour: 0,
                                              currency: value.currency!,
                                              totalPrice: value.price!,
                                              pricePerDay: value.pricePerDay,
                                              carImage: widget.carImage,
                                              gasoline: value.gasoline!,
                                              carSeat: value.carSeat!,
                                              insurance: value.insurance!,
                                              smokingCar: value.smokingCar!,
                                              ashtray: value.ashtray!,
                                            ));
                                        setState(() {
                                          isLoadingButton = false;
                                          dropDownValueStart = '';
                                          dropDownValueEnd = '';
                                        });
                                      } else if (value.status == 0) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("message".tr),
                                              content: Text(
                                                value.message.toString(),
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
                                    });
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

                                //   setState(() {
                                //     checkStart = false;
                                //     checkEnd = false;
                                //   });
                                //   final first = DateTime(
                                //       widget.firstYear,
                                //       widget.firstMonth,
                                //       widget.firstDay,
                                //       widget.firstHour);
                                //   final second = DateTime(
                                //       widget.secondYear,
                                //       widget.secondMonth,
                                //       widget.secondDay,
                                //       widget.secondHour);
                                //   // final second = secondController;
                                //   difference =
                                //       (second.difference(first).inDays);

                                //   if (difference > 0) {
                                //     differenceHours =
                                //         widget.firstHour - widget.secondHour;
                                //     push(
                                //         context,
                                //         ConfirmInformation(
                                //           typeCar: typeCAR,
                                //           startTime: widget.firstTime,
                                //           startDate: widget.firstDate,
                                //           returnDate: widget.lastDate,
                                //           returnTime: widget.endTime,
                                //           firstLocation: dropDownValueStart,
                                //           endLocation: dropDownValueEnd,
                                //           numberOfDay: difference,
                                //           numberOfHour: differenceHours,
                                //         ));
                                //   } else if (difference == 0) {
                                //     differenceHours =
                                //         widget.secondHour - widget.firstHour;
                                //     if (differenceHours > 0) {
                                //       push(
                                //           context,
                                //           ConfirmInformation(
                                //             typeCar: typeCAR,
                                //             startTime: widget.firstTime,
                                //             startDate: widget.firstDate,
                                //             returnDate: widget.lastDate,
                                //             returnTime: widget.endTime,
                                //             firstLocation: dropDownValueStart,
                                //             endLocation: dropDownValueEnd,
                                //             numberOfDay: difference,
                                //             numberOfHour: differenceHours,
                                //           ));
                                //     } else {
                                //       showMessage(
                                //           context: context,
                                //           text: "Please Enter Correct Date");
                                //     }
                                //   }
                              }),
                        )),

                        SizedBox(
                          height: _height * .02,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Future fetchIsCarAvailable() async {
    String apiUrl = ApiApp.isAvaliableCars;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token');

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
      "token": _sharedToken,
    };
    print("this is my majd$json");
    http.Response response =
        await http.post(Uri.parse(apiUrl), body: json, headers: {
      'Accept': 'application/json',
    });
    print(response.statusCode);
    print(response.body);
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse["status"] == 422 || jsonResponse["status"] == 400) {
      showDialog(
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
    //return x;
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
