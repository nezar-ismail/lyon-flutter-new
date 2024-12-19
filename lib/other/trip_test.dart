// ignore_for_file: prefer_typing_uninitialized_variables, duplicate_ignore, use_build_context_synchronously

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lyon/model/transportation_from_to.dart';
import 'package:lyon/other/confirmation.dart';
import 'package:lyon/other/payment_page_transpotation.dart';
import 'package:lyon/screen/trip_check_out/trip_check_out.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/trip_check_out_controller.dart/trip_check_out_controller.dart';
import 'package:lyon/v_done/utils/Translate/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../api/api.dart';
import '../shared/Widgets/text_field_widget.dart';
// import '../shared/mehod/message.dart';
import '../shared/styles/colors.dart';
// import 'main_screen.dart';

class TripTest extends StatefulWidget {
  const TripTest({super.key, required this.image, this.type});
  final String image;
  final String? type;

  @override
  State<TripTest> createState() => _TripTestState();
}

class _TripTestState extends State<TripTest> {
  final List<TransportationFromTo> transportationFromList = [];
  // ignore: prefer_typing_uninitialized_variables
  var _selectedItem;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> text = ["one_way".tr, "multi_way".tr, "full_program".tr];
  String wayType = '';
  var prices = {};
  List<String> locationStart = [];
  List<String> locationStartAr = [];
  List<String> locationTo = [];
  List<String> locationToAr = [];
  List<String> locationToArabic = [];
  List<String> idDestnationTo = [];
  List<String> idDestnationFrom = [];
  List<String> requireTicket = [];
  bool locationsWayLoading = false;
  bool locationsWayLoading2 = true;
  bool locationToLoading = true;
  String destnationFrom = '';
  String destnationTo = '';
  var selectedID;
  var selectedIDTo;
  double totalPrice = 0.0;
  var currency;
  bool isLoading = true;
  String locationTicket = '';
  TripCheckOutController tripCheckOutController = Get.find();

  Future<void> selectDate({
    required BuildContext context,
    required TextEditingController dateController,
    selectedDate,
    firstDate,
  }) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: DateTime((DateTime.now().year) + 3, 12),
        errorInvalidText: "Out of range");

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
      });
    }
  }

  Future<void> selectTime(
      {required BuildContext context,
      required TextEditingController timeController}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      // time = pickedTime.format(context);
      DateTime parsedTime =
          // ignore: use_build_context_synchronously
          DateFormat.Hm().parse(pickedTime.format(context).toString());
      // ignore: unused_local_variable
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      setState(() {
        timeController.text = pickedTime.format(context);
        // firstHour = pickedTime.hour;
        // firstMinute = pickedTime.minute;
      });
    }
  }

  checkUserDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    String apiUrl = ApiApp.checkUserDocuments;
    final json = {"token": sharedToken, "mobile": "1"};

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  @override
  void initState() {
    checkUserDocuments().then((value) {
      if (value == 2 || value == 3) {
        setState(() {
          //isVisiblePassport = false;
          isLoading = false;
        });
      } else {
        setState(() {
          //isVisiblePassport = true;
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  var idFullDay;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        floatingActionButton:
            totalPrice == 0.0 && destnationFrom != '' && destnationTo != ''
                ? GestureDetector(
                    onTap: () async {
                      var url = Uri.parse("https://wa.me/962777477748");

                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    child: Image.asset(
                      "assets/images/whatsapp_logo.png",
                      width: 60,
                    ),
                  )
                : const SizedBox(),
        appBar: AppBar(
          backgroundColor: secondaryColor1,
          title: Text('select_destination'.tr),
          centerTitle: true,
        ),
        body: isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SizedBox(
                    width: width * .90,
                    height: height * .80,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height * .02,
                                ),
                                Center(
                                    child: Image.asset(widget.image,
                                        width: width / 2)),
                                SizedBox(
                                  height: height * .02,
                                ),
                                SizedBox(
                                  height: height / 4,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: text.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return RadioListTile(
                                        title: Text(text[index]),
                                        value: index,
                                        groupValue: _selectedItem,
                                        onChanged: (value) async {
                                          setState(() {
                                            locationsWayLoading2 = true;
                                            locationToLoading = true;
                                            locationStart = [];
                                            locationTo = [];
                                            locationStartAr = [];
                                            destnationFrom = '';
                                            destnationTo = '';
                                            _selectedItem = value;
                                            totalPrice = 0.0;
                                            //isVisibleTicket = false;
                                            locationStart = [];
                                            locationTo = [];
                                            idDestnationTo = [];
                                            idDestnationFrom = [];
                                          });

                                          if (_selectedItem == 0) {
                                            setState(() {
                                              wayType = 'one_way';
                                            });
                                          }
                                          if (_selectedItem == 1) {
                                            setState(() {
                                              wayType = 'multi_way';
                                            });
                                          }
                                          if (_selectedItem == 2) {
                                            setState(() {
                                              wayType = 'full_day';
                                            });
                                          }
                                          String apiUrl =
                                              ApiApp.getTransportationRoutes;
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var token =
                                              prefs.getString('access_token');
                                          http.Response response = await http
                                              .post(Uri.parse(apiUrl), body: {
                                            "token": token,
                                            "type": widget.type,
                                            "mobile": "1",
                                            "wayType": wayType
                                          }).whenComplete(() {
                                            setState(() {
                                              locationsWayLoading = true;
                                              locationsWayLoading2 = false;
                                              if (kDebugMode) {
                                                print(
                                                  "token is: $token, type is: ${widget.type}, wayType is: $wayType");
                                              }
                                            });
                                            if (kDebugMode) {
                                              print(LocalizationService()
                                                .getCurrentLang());
                                            }
                                          });

                                          var jsonResponse =
                                              jsonDecode(response.body);
                                          for (var i = 0;
                                              i < jsonResponse.length;
                                              i++) {
                                            locationStartAr
                                                .add(jsonResponse[i]['start']);
                                            locationStart.add(
                                                LocalizationService()
                                                            .getCurrentLang() ==
                                                        'Arabic'
                                                    ? jsonResponse[i]
                                                        ['start_ar']
                                                    : jsonResponse[i]['start']);
                                            if (_selectedItem == 2) {
                                              setState(() {
                                                idFullDay =
                                                    jsonResponse[i]['id'];
                                              });
                                            }
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                                locationsWayLoading2 == true && wayType != ''
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : locationsWayLoading == false
                                        ? Container()
                                        : SizedBox(
                                            width: width * .75,
                                            child: DropdownSearch<String>(
                                              /* dropdownSearchDecoration:
                                              const InputDecoration(
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  secondaryColor1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                  border: InputBorder.none,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: secondaryColor1),
                                                      borderRadius:
                                                          BorderRadius.all(Radius
                                                              .circular(10))),
                                                  contentPadding: EdgeInsets.only(
                                                      right: 20, left: 20)),
                                          popupBarrierColor:
                                              Colors.black.withOpacity(.5),
                                          validator: (value) => value == null
                                              ? 'please_select_pickup_location'.tr
                                              : null,
                                          mode: Mode.DIALOG,
                                          items: locationStart,
                                          showSearchBox: true,
                                          // ignore: deprecated_member_use
                                          label: "pickup_location".tr, */
                                              // label: "First Location",
                                              dropdownDecoratorProps:
                                                  const DropDownDecoratorProps(
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                label: Text("Pick up location"),
                                              )),
                                              items: locationStart,
                                              validator: (value) => value ==
                                                      null
                                                  ? 'please_select_pickup_location'
                                                      .tr
                                                  : null,
                                              popupProps: const PopupProps.menu(
                                                showSearchBox: true,
                                              ),
                                              onChanged: (value) async {
                                                if (kDebugMode) {
                                                  print(locationStartAr);
                                                }

                                                setState(() {
                                                  locationTo.clear();
                                                  locationToAr.clear();
                                                  locationToArabic.clear();
                                                  // isVisibleTicket = false;
                                                  totalPrice = 0.0;
                                                  destnationTo = '';
                                                  destnationFrom = '';
                                                  "--- $locationStart ---";
                                                  destnationFrom =
                                                      locationStartAr[
                                                          locationStart
                                                              .indexOf(value!)];
                                                  if (kDebugMode) {
                                                    print(destnationFrom);
                                                  }
                                                  locationTo.clear();
                                                  locationToAr.clear();
                                                  locationToArabic.clear();
                                                  if (destnationTo != '') {
                                                    push(
                                                        context,
                                                        TripTest(
                                                            image:
                                                                widget.image));
                                                  }
                                                });
                                                if (kDebugMode) {
                                                  print(
                                                    "Here is the pickup spot: $destnationFrom");
                                                }
                                                locationToLoading = true;
                                                String apiUrl = ApiApp
                                                    .getTransportationFromTo;
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                var token = prefs
                                                    .getString('access_token');
                                                http.Response response =
                                                    await http.post(
                                                        Uri.parse(apiUrl),
                                                        body: {
                                                      "token": token,
                                                      "type": widget.type,
                                                      "mobile": "1",
                                                      "wayType": wayType,
                                                      "fromDes": destnationFrom
                                                    }).whenComplete(() {
                                                  if (kDebugMode) {
                                                    print(value);
                                                  }
                                                  setState(() {
                                                    locationToLoading = false;
                                                    if (kDebugMode) {
                                                      print(locationTo);
                                                    }
                                                  });
                                                });

                                                if (_selectedItem != 2) {
                                                  var jsonResponse =
                                                      jsonDecode(response.body);
                                                  if (kDebugMode) {
                                                    print(
                                                      jsonResponse.toString());
                                                  }
                                                  locationToAr.clear();
                                                  locationToArabic.clear();
                                                  locationTo.clear();
                                                  idDestnationTo.clear();
                                                  for (var i = 0;
                                                      i < jsonResponse.length;
                                                      i++) {
                                                    locationToAr.add(
                                                        jsonResponse[i]
                                                            ['end_ar']);
                                                    locationToArabic
                                                        .add(locationToAr[i]);

                                                    // prices[jsonResponse[i]["start"]] = {};

                                                    locationTo.add(
                                                        jsonResponse[i]['end']);

                                                    // locationToAr.removeRange(
                                                    //     locationTo.length - 1,
                                                    //     locationToAr.length -
                                                    //         1);
                                                    idDestnationTo.add(
                                                        jsonResponse[i]['id']);

                                                    idDestnationFrom.add(
                                                        jsonResponse[i]['id']);
                                                    requireTicket.add(
                                                        jsonResponse[i]
                                                            ['requireTicket']);
                                                  }

                                                  // print(locationStart.length);
                                                  if (kDebugMode) {
                                                    print(locationTo.length);
                                                  }
                                                  if (kDebugMode) {
                                                    print(locationToAr.length);
                                                  }
                                                  if (kDebugMode) {
                                                    print(destnationFrom.length);
                                                  }
                                                  // print(destnationTo.length);
                                                  if (kDebugMode) {
                                                    print(idDestnationTo.length);
                                                  }
                                                  if (kDebugMode) {
                                                    print(
                                                      locationToArabic.length);
                                                  }

                                                  int?
                                                      selectedIndexrequireTicket;
                                                  setState(() {
                                                    selectedIndexrequireTicket =
                                                        locationStart
                                                            .indexOf(value!);
                                                    selectedID =
                                                        idDestnationFrom.last;
                                                  });
                                                  if (selectedIndexrequireTicket! >=
                                                          0 &&
                                                      selectedIndexrequireTicket! <
                                                          requireTicket
                                                              .length) {
                                                    if (requireTicket[
                                                            selectedIndexrequireTicket!] ==
                                                        '1') {
                                                      setState(() {
                                                        //isVisibleTicket = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        // isVisibleTicket = false;
                                                        // isCheckTicket = false;
                                                        // isUploadTicketSuccess =
                                                        //     false;
                                                      });
                                                    }
                                                  }
                                                } else if (wayType ==
                                                        'full_day' ||
                                                    _selectedItem == 2) {
                                                  apiUrl = ApiApp
                                                      .getTransportationFromPrice;
                                                  http.Response response2 =
                                                      await http.post(
                                                          Uri.parse(apiUrl),
                                                          body: {
                                                        "token": token,
                                                        "type": widget.type,
                                                        "mobile": "1",
                                                        "wayType": wayType,
                                                        "id": idFullDay
                                                      });
                                                  var jsonResponse2 =
                                                      jsonDecode(
                                                          response2.body);
                                                  if (kDebugMode) {
                                                    print(
                                                      "The first 1st print: $currency");
                                                  }
                                                  setState(() {
                                                    totalPrice =
                                                        jsonResponse2['price']
                                                            .toDouble();

                                                    currency = jsonResponse2[
                                                        'currency'];
                                                    if (kDebugMode) {
                                                      print(
                                                        "The first 2nd print: $currency");
                                                    }
                                                  });
                                                }
                                              },
                                              filterFn: (instance, filter) {
                                                if (instance.contains(filter)) {
                                                  return true;
                                                } else if (instance
                                                    .toLowerCase()
                                                    .contains(
                                                        filter.toLowerCase())) {
                                                  return true;
                                                } else {
                                                  return false;
                                                }
                                              },
                                            ),
                                          ),
                                SizedBox(
                                  height: height * .02,
                                ),

                                wayType == 'full_day'
                                    ? Container()
                                    : destnationFrom == ''
                                        ? Container()
                                        : locationToLoading == true
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : SizedBox(
                                                width: width * .75,
                                                child: DropdownSearch<String>(
                                                  dropdownDecoratorProps:
                                                      const DropDownDecoratorProps(
                                                          dropdownSearchDecoration:
                                                              InputDecoration(
                                                    label: Text(
                                                        "Drop off location"),
                                                  )),
                                                  items: LocalizationService()
                                                              .getCurrentLang() ==
                                                          "Arabic"
                                                      ? locationToArabic
                                                      : locationTo,
                                                  validator: (value) => value ==
                                                          null
                                                      ? 'please_select_dropoff_location'
                                                          .tr
                                                      : null,
                                                  onChanged: (value) async {
                                                    setState(() {
                                                      destnationTo = LocalizationService()
                                                                  .getCurrentLang() ==
                                                              "Arabic"
                                                          ? locationToArabic[
                                                              locationToArabic
                                                                  .indexOf(
                                                                      value!)]
                                                          : locationTo[
                                                              locationTo
                                                                  .indexOf(
                                                                      value!)];
                                                      if (kDebugMode) {
                                                        print(destnationTo);
                                                      }
                                                      int selectedIndex =
                                                          LocalizationService()
                                                                      .getCurrentLang() ==
                                                                  "Arabic"
                                                              ? locationToArabic
                                                                  .indexOf(
                                                                      value)
                                                              : locationTo
                                                                  .indexOf(
                                                                      value);

                                                      if (kDebugMode) {
                                                        print(
                                                          "The selected index: $selectedIndex");
                                                      }
                                                      if (kDebugMode) {
                                                        if (kDebugMode) {
                                                      }
                                                        print(idDestnationTo);
                                                      }
                                                      selectedIDTo =
                                                          idDestnationTo[
                                                              selectedIndex];
                                                    });
                                                    String apiUrl = ApiApp
                                                        .getTransportationFromPrice;
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    var token =
                                                        prefs.getString(
                                                            'access_token');
                                                    http.Response response =
                                                        await http.post(
                                                            Uri.parse(apiUrl),
                                                            body: {
                                                          "token": token,
                                                          "type": widget.type,
                                                          "mobile": "1",
                                                          "wayType": wayType,
                                                          "id": selectedIDTo
                                                        });
                                                    var jsonResponse =
                                                        jsonDecode(
                                                            response.body);

                                                    if (kDebugMode) {
                                                      print(jsonResponse);
                                                    }
                                                    setState(() {
                                                      currency = (jsonResponse[
                                                              'currency'])
                                                          .toString();
                                                      if (kDebugMode) {
                                                        print(
                                                          "id for me: $selectedID type:  ${widget.type}  wayType: $wayType");
                                                      }

                                                      if (kDebugMode) {
                                                        print(jsonResponse[
                                                          'price']);
                                                      }
                                                      totalPrice =
                                                          jsonResponse['price']
                                                              .toDouble();
                                                      destnationTo =
                                                          LocalizationService()
                                                                      .getCurrentLang() ==
                                                                  "Arabic"
                                                              ? locationTo[
                                                                  locationToArabic
                                                                      .indexOf(
                                                                          value!)]
                                                              : value!;
                                                    });
                                                  },
                                                  filterFn: (instance, filter) {
                                                    if (instance
                                                        .contains(filter)) {
                                                      return true;
                                                    } else if (instance
                                                        .toLowerCase()
                                                        .contains(filter
                                                            .toLowerCase())) {
                                                      return true;
                                                    } else {
                                                      return false;
                                                    }
                                                  },
                                                ),
                                              ),
                                destnationTo == '' && wayType != 'full_day'
                                    ? Container()
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: height * .02,
                                          ),
                                          SizedBox(
                                            width: width * .75,
                                            // height: _height * .1,
                                            child:
                                                textFieldWidgetWithoutFilledWithFunction(
                                                    context: context,
                                                    hintText: "pickup_date".tr,
                                                    controller: dateController,
                                                    icons: const Icon(
                                                      Icons.calendar_today,
                                                    ),
                                                    fun: () => selectDate(
                                                          context: context,
                                                          dateController:
                                                              dateController,
                                                          selectedDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                        ),
                                                    textValidatorEmpty:
                                                        "please_enter_date".tr),
                                          ),
                                          SizedBox(
                                            height: height * .02,
                                          ),
                                          SizedBox(
                                            width: width * .75,
                                            // height: _height * .1,
                                            child:
                                                textFieldWidgetWithoutFilledWithFunctionSmall(
                                              context: context,
                                              fun: () {
                                                selectTime(
                                                    context: context,
                                                    timeController:
                                                        timeController);
                                              },
                                              icons:
                                                  const Icon(Icons.access_time),
                                              controller: timeController,
                                              hintText: "start_time".tr,
                                              textValidatorEmpty:
                                                  "please_enter_time".tr,
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: height * .02,
                                ),
                                // Spacer(),

                                totalPrice == 0.0
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'total_price'.tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                              // ignore: prefer_interpolation_to_compose_strings
                                              '${totalPrice.toString().substring(0, totalPrice.toString().indexOf('.'))} ' +
                                                  currency,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20))
                                        ],
                                      ),
                                SizedBox(
                                  height: height * .01,
                                ),
                                totalPrice == 0.0 &&
                                        destnationFrom != '' &&
                                        destnationTo != ''
                                    ? Column(
                                        children: [
                                          Text(
                                            "This_trip_is_not_avaliable".tr,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "contact_us_for_more_details".tr,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  height: height * .01,
                                ),

                                destnationFrom == '' || totalPrice == 0.0
                                    ? Container()
                                    : SizedBox(
                                        width: width * .50,
                                        height: height * .05,
                                        // ignore: deprecated_member_use
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: secondaryColor1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                          child: Text(
                                            'continue'.tr,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            if (kDebugMode) {
                                              print("DestTo: $destnationTo");
                                            }
                                            if (_formKey.currentState!
                                                .validate()) {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeCap:
                                                            StrokeCap.square,
                                                        strokeWidth: 5,
                                                      ),
                                                    );
                                                  });

                                              var result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ConfirmationScreen(
                                                      fromLocation:
                                                          destnationFrom,
                                                      toLocation: destnationTo,
                                                      date: dateController.text,
                                                      time: timeController.text,
                                                      carType:
                                                          widget.type ?? 'Car',
                                                      price:
                                                          totalPrice.toString(),
                                                      tripType: wayType,
                                                      currency: currency,
                                                    ),
                                                    fullscreenDialog: true,
                                                  ));
                                              if (result == false) {
                                                Navigator.of(context).pop();
                                              } else {
                                                bool passportInserted =
                                                    await tripCheckOutController
                                                        .checkIfUserInsertedPassport();
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    bool isChecked = false;
                                                    return StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                      return AlertDialog(
                                                          backgroundColor: Colors
                                                              .grey.shade300,
                                                          title: Text(
                                                              "terms_and_conditions"
                                                                  .tr),
                                                          content: SizedBox(
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: ListView(
                                                              shrinkWrap: true,
                                                              children: [
                                                                Text(
                                                                    '\u2022 ${'term1_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term4_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term5_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term6_trip'.tr}\n\n    -	${'term6_trip_1'.tr}\n    -	${'term6_trip_2'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term7_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term8_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term9_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term10_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term11_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term12_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term13_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term14_trip'.tr}\n'),
                                                                Text(
                                                                    '\u2022 ${'term15_trip'.tr}\n\n    -	${'term15_trip_1'.tr}\n    -	${'term15_trip_2'.tr}\n'),
                                                                CheckboxListTile(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  title: Text(
                                                                      'i_read_and_agree'
                                                                          .tr),
                                                                  value:
                                                                      isChecked,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked =
                                                                          value!;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          //
                                                          actions: (destnationFrom.trim() == "مطار الملكه علياء" ||
                                                                  destnationFrom
                                                                          .trim() ==
                                                                      "Airport Queen Alia" ||
                                                                  destnationFrom
                                                                          .trim() ==
                                                                      "Queen Alia Airport" ||
                                                                  destnationFrom
                                                                          .trim() ==
                                                                      "مطار الملكه عليا")
                                                              ? <Widget>[
                                                                  isChecked ==
                                                                          false
                                                                      // ignore: deprecated_member_use
                                                                      ? const TextButton(
                                                                          onPressed:
                                                                              null,
                                                                          child:
                                                                              Text('ok'),
                                                                        )
                                                                      // ignore: deprecated_member_use
                                                                      : TextButton(
                                                                          child:
                                                                              const Text("ok"),
                                                                          onPressed:
                                                                              () async {
                                                                            if (kDebugMode) {
                                                                              print("The location ticket: $locationTicket");
                                                                            }
                                                                            if (kDebugMode) {
                                                                              print("The start date is: ${dateController.text}");
                                                                            }
                                                                            if (kDebugMode) {
                                                                              print("The time is: ${timeController.text}");
                                                                            }
                                                                            if (kDebugMode) {
                                                                              if (kDebugMode) {
                                                                            }
                                                                              print("The total price: ${totalPrice.toString()}");
                                                                            }
                                                                            if (kDebugMode) {
                                                                              print("The vehicle type: ${widget.type}");
                                                                            }
                                                                            if (kDebugMode) {
                                                                              print("The currency, and the wayType is: $currency and $wayType");
                                                                            }
                                                                            if (kDebugMode) {
                                                                              print("test222  $destnationTo");
                                                                            }
                                                                            push(
                                                                                context,
                                                                                TripCheckOut(
                                                                                  pickupSpot: destnationFrom,
                                                                                  dropOffSpot: destnationTo,
                                                                                  totalPrice: totalPrice.toString().substring(0, totalPrice.toString().indexOf('.')),
                                                                                  currency: currency,
                                                                                  wayType: wayType,
                                                                                  destination: _selectedItem == 2 ? idFullDay : selectedIDTo,
                                                                                  startTime: timeController.text,
                                                                                  startDate: dateController.text,
                                                                                  locationTicket: locationTicket,
                                                                                  vehicleType: widget.type,
                                                                                ));
                                                                          },
                                                                        ),
                                                                  // ignore: deprecated_member_use
                                                                  TextButton(
                                                                    child: Text(
                                                                        "cancel"
                                                                            .tr),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ]
                                                              : passportInserted
                                                                  ? <Widget>[
                                                                      isChecked ==
                                                                              false
                                                                          // ignore: deprecated_member_use
                                                                          ? const TextButton(
                                                                              onPressed: null,
                                                                              child: Text('ok'),
                                                                            )
                                                                          // ignore: deprecated_member_use
                                                                          : TextButton(
                                                                              child: const Text("ok"),
                                                                              onPressed: () {
                                                                                if (kDebugMode) {
                                                                                  print(locationTicket);
                                                                                }
                                                                                if (kDebugMode) {
                                                                                  print(dateController.text);
                                                                                }
                                                                                if (kDebugMode) {
                                                                                  if (kDebugMode) {
                                                                                }
                                                                                  print(timeController.text);
                                                                                }
                                                                              
                                                                                push(
                                                                                  context,
                                                                                  CashOrVisaTranspotation(
                                                                                    locationTicket: locationTicket,
                                                                                    startDate: dateController.text,
                                                                                    startTime: timeController.text,
                                                                                    totalPrice: totalPrice.toString().substring(0, totalPrice.toString().indexOf('.')),
                                                                                    vehicleType: widget.type,
                                                                                    destination: _selectedItem == 2 ? idFullDay : selectedIDTo,
                                                                                    currency: currency,
                                                                                    wayType: wayType,
                                                                                    startLocation: destnationFrom,
                                                                                    endLocation: destnationTo,
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                      // ignore: deprecated_member_use
                                                                      TextButton(
                                                                        child: Text(
                                                                            "cancel".tr),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ]
                                                                  : <Widget>[
                                                                      isChecked ==
                                                                              false
                                                                          // ignore: deprecated_member_use
                                                                          ? TextButton(
                                                                              onPressed: null,
                                                                              child: Text('ok'.tr),
                                                                            )
                                                                          // ignore: deprecated_member_use
                                                                          : TextButton(
                                                                              child: Text("ok".tr),
                                                                              onPressed: () async {
                                                                                push(
                                                                                    context,
                                                                                    TripCheckOut(
                                                                                      pickupSpot: destnationFrom,
                                                                                      dropOffSpot: destnationTo,
                                                                                      totalPrice: totalPrice.toString().substring(0, totalPrice.toString().indexOf('.')),
                                                                                      currency: currency,
                                                                                      wayType: wayType,
                                                                                      destination: _selectedItem == 2 ? idFullDay : selectedIDTo,
                                                                                      startTime: timeController.text,
                                                                                      startDate: dateController.text,
                                                                                      locationTicket: locationTicket,
                                                                                      vehicleType: widget.type,
                                                                                    ));
                                                                              },
                                                                            ),
                                                                      // ignore: deprecated_member_use
                                                                      TextButton(
                                                                        child: Text(
                                                                            "cancel".tr),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ]);
                                                    });
                                                  },
                                                );
                                                // } else if (isVisiblePassport ==
                                                //         true &&
                                                //     isVisibleTicket == true) {
                                                //   setState(() {
                                                //     isCheckPassport = true;
                                                //     isCheckTicket = true;
                                                //   });
                                                // } else if (isVisibleTicket ==
                                                //     true) {
                                                //   setState(() {
                                                //     isCheckTicket = true;
                                                //   });
                                                // } else if (isVisiblePassport ==
                                                //     true) {
                                                //   setState(() {
                                                //     isCheckPassport = true;
                                                //   });
                                                // }
                                              }
                                            }
                                          },
                                        )),
                                SizedBox(
                                  height: height * .05,
                                ),
                              ],
                            ),
                          ),
                        )))));
  }
}
