// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/api/method_api.dart';
import 'package:lyon/other/available_car.dart';
import 'package:lyon/other/details_view.dart';
import 'package:lyon/shared/Widgets/appbar.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rental extends StatefulWidget {
  const Rental({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RentalState createState() => _RentalState();
}

class _RentalState extends State<Rental> {
  TextEditingController firstDateController = TextEditingController();
  TextEditingController firstTimeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime? selectedDate;
  DateTime? firstDate;
  DateTime? lastDate;
  DateTime? firstController;
  DateTime? secondController;
  int? difference;
  int? differenceHours;
  DateFormat format = DateFormat("yyyy-MM-dd");

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
    // var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    // var inputDate = inputFormat.parse('31/12/2000 23:59');

    // if (firstDateController.text == null) {
    //   return null;
    // }
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
      // ignore: duplicate_ignore
      // ignore: use_build_context_synchronously
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
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
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

        // secondHour = pickedTime.hour;
        // secondMinute = pickedTime.minute;
      });
    }
  }

  // List<Cars> listCar = [];
  bool openLoading = true;
  List<String> carsName = [];
  List<int> carsPrice = [];
  List<String> carsImage = [];
  List<int> carsId = [];
  List<String> currency = [];
  List<String> gasolinType = [];

  Future getCarFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');

    final json = {
      "token": sharedToken,
      "mobile": "1",
    };

    await MethodAppApi()
        .methodPOSTReturnResponse(url: ApiApp.getCar, body: json, headers: {
      'Accept': 'application/json',
    }).then((value) {
      int length = value['count'];
     
      

      for (int i = 0; i < length; i++) {
        carsId.add(value['data'][i]['id']);
        carsName.add(value['data'][i]['name']);
        currency.add(value['data'][i]['currency']);
        carsPrice.add(value['data'][i]['price']);
        carsImage.add(value['data'][i]['thumbnail']);
        gasolinType.add(value['data'][i]['type']);
      }
    });
  }

  @override
  void initState() {
    // deleteUnCompleteOrder();
    getCarFromApi().whenComplete(() {
      if (mounted) {
        setState(() {
          openLoading = false;
        });
      }
    });
    super.initState();
  }

  // deleteUnCompleteOrder() async {
  //   setState(() {
  //     openLoading = true;
  //   });
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   var _sharedToken = _prefs.getString('access_token');
  //   final json = {"token": _sharedToken, "mobile": "1"};
  //   http.Response response =
  //       await http.post(Uri.parse(ApiApp.deleteUnCompleteOrder), body: json);

  //   var jsonResponse = jsonDecode(response.body);
  //   print(jsonResponse.toString());
  //   if (jsonResponse['status'] != null) {
  //     getCarFromApi().whenComplete(() {
  //       if (mounted) {
  //         setState(() {
  //           openLoading = false;
  //         });
  //       }
  //     });
  //   }
  // }

  final _formKey = GlobalKey<FormState>();

  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final expandedHeight = height * .29;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBars(
          text: "rental".tr,
          context: context,
          withIcon: false,
          canBack: true,
          endDrawer: true,
        ),
        backgroundColor: backgroundColor,
        body: openLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 15),
                child: NestedScrollView(
                  body: _gridView(context, orientation),
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        expandedHeight: expandedHeight,
                        floating: false,
                        pinned: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            children: [
                              Positioned.fill(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        "car available".tr,
                                        style: TextStyle(
                                            color: secondaryColor1,
                                            fontSize: width * .05,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child:
                                                textFieldWidgetWithoutFilledWithFunctionSmall(
                                              context: context,
                                              fun: () {
                                                setState(() {
                                                  endDateController.text = '';
                                                });
                                                _selectDateFirst(
                                                  context: context,
                                                  dateController:
                                                      firstDateController,
                                                  selectedDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(
                                                      (DateTime.now().year) + 3,
                                                      12),
                                                );
                                              },
                                              icons: const Icon(
                                                  Icons.calendar_today),
                                              controller: firstDateController,
                                              hintText: "start_date".tr,
                                              textValidatorEmpty:
                                                  "please_enter_start_date".tr,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child:
                                                textFieldWidgetWithoutFilledWithFunctionSmall(
                                              context: context,
                                              fun: () {
                                                _selectTimeFirst(
                                                    context: context,
                                                    timeController:
                                                        firstTimeController);
                                              },
                                              icons:
                                                  const Icon(Icons.access_time),
                                              controller: firstTimeController,
                                              hintText: "start_time".tr,
                                              textValidatorEmpty:
                                                  "please_enter_start_time".tr,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child:
                                                textFieldWidgetWithoutFilledWithFunctionSmall(
                                              context: context,
                                              fun: firstController == null
                                                  ? () {}
                                                  : () {
                                                      _selectDateSecond(
                                                        context: context,
                                                        dateController:
                                                            endDateController,
                                                        firstDate:
                                                            DateTime.now(),
                                                        selectedDate:
                                                            firstController,
                                                        lastDate:
                                                            firstController!.add(
                                                                const Duration(
                                                                    days: 35)),
                                                      );
                                                    },
                                              icons: const Icon(
                                                  Icons.calendar_today),
                                              controller: endDateController,
                                              hintText: "end_date".tr,
                                              textValidatorEmpty:
                                                  "please_enter_end_date".tr,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child:
                                                textFieldWidgetWithoutFilledWithFunctionSmall(
                                              context: context,
                                              fun: () {
                                                _selectTimeSecond(
                                                    context: context,
                                                    timeController:
                                                        endTimeController);
                                              },
                                              icons:
                                                  const Icon(Icons.access_time),
                                              controller: endTimeController,
                                              hintText: "end_time".tr,
                                              textValidatorEmpty:
                                                  "please_enter_end_time".tr,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * .01,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (firstDateController
                                                  .text.isNotEmpty &&
                                              endDateController.text.isEmpty) {
                                            _formKey.currentState!.validate();
                                          } else {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              push(
                                                  context,
                                                  AvailableCars(
                                                    firstDate:
                                                        firstDateController
                                                            .text,
                                                    firstTime:
                                                        firstTimeController
                                                            .text,
                                                    endDate:
                                                        endDateController.text,
                                                    endTime:
                                                        endTimeController.text,
                                                  ));
                                            }
                                          }
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: height * .07,
                                          decoration: const BoxDecoration(
                                              color: secondaryColor1,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Center(
                                              child: Text(
                                            "search".tr,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .05),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                ),
              ),
      ),
    );
  }

  MediaQuery _gridView(BuildContext context, Orientation orientation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .01,
              left: MediaQuery.of(context).size.width * .01,
              right: MediaQuery.of(context).size.width * .01),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 2),
          itemCount: carsName.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * .001),
              child: GestureDetector(
                onTap: () => push(
                    context,
                    DetailsView(
                      id: carsId[index],
                    )),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .003),
                      Text(
                        '${carsName[index]}\n',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .030,
                            fontWeight: FontWeight.bold),
                      ),
                      Image.network(
                        'https://lyon-jo.com/${carsImage[index]}',
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height * .09,
                        //color: Colors.transparent,
                      ),
                      Text(
                        gasolinType[index].toString(),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.width * .03,
                        ),
                      ),
                      Text(
                        "${carsPrice[index]} ${currency[index]}",
                        style: TextStyle(
                          color: colorPrimary,
                          fontSize: MediaQuery.of(context).size.width * .05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "per_day_month".tr,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.width * .03,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
