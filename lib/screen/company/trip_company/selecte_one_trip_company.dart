// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/screen/company/trip_company/details_one_trip_company.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SelecteOneTripCompany extends StatefulWidget {
  final String type;
  final String image;
  final String numTrip;
  const SelecteOneTripCompany({
    super.key,
    required this.image,
    required this.type,
    required this.numTrip,
  });

  @override
  State<SelecteOneTripCompany> createState() => _SelecteOneTripCompanyState();
}

class _SelecteOneTripCompanyState extends State<SelecteOneTripCompany> {
  int count = 1;
  String? destinationValue;
  String? locationValue;
  int phoneNumberLength = 20;
  List<Map<String, dynamic>> mapMobile = [];
  List date = [];
  List<Map<String, dynamic>> jsonApiTotalPrice = [];
  List<TextEditingController> dateController =
      List.generate(12, (i) => TextEditingController());
  List<TextEditingController> timeController =
      List.generate(12, (i) => TextEditingController());
  bool isLoading = true;
  List time = [];
  var dates = [];
  List webJson = [];
  String vehicleType = '';
  int isCompany = 0;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController projectName = TextEditingController();
  TextEditingController note = TextEditingController();

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
            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
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
          DateFormat.Hm().parse(pickedTime.format(context).toString());
      // ignore: unused_local_variable
      String formattedTime = DateFormat('HH:mm').format(parsedTime);
      setState(() {
        timeController.text = pickedTime.format(context);
        // firstHour = pickedTime.hour;
        // firstMinute = pickedTime.minute;
      });
    }
  }

  List<String> locations = [];
  var isMultiLocation = false;
  getTransportationRoutes() async {
    String apiUrl = ApiApp.getAllCompanyTransportations;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('access_token_company');
    http.Response response = await http
        .post(Uri.parse(apiUrl), body: {"token": token, "mobile": "1"});

    var jsonResponse = jsonDecode(response.body);
    for (var i = 0; i < jsonResponse.length; i++) {
      if (jsonResponse[i]['location'] == null) {
        setState(() {
          isMultiLocation = true;
        });
        locations.add(jsonResponse[i]['locations']);
      } else {
        locations.add(jsonResponse[i]['location']);
      }
    }
  }

  Future<int> checkCompanyType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token_company');

    var response = await http.post(
        Uri.parse("https://lyon-jo.com/api/checkCompanyTypeTrip.php"),
        body: {
          'token': sharedToken.toString(),
        });

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse["status"] == 200) {
      setState(() {
        isCompany = int.parse(jsonResponse["message"]);
      });
    }
    return jsonResponse["message"];
  }

  // final List<GlobalObjectKey<FormState>> formKeyList =
  //     List.generate(12, (index) => GlobalObjectKey<FormState>(index));
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // checkCompanyType();
    // getTransportationRoutes().then((value) {
    //   if (mounted) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    //  if (mounted) {
    //      setState(() {
    isLoading = false;
    // });}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return isLoading == true
        ? const Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            appBar: AppBar(
              title: Text('trip'.tr),
              centerTitle: true,
              backgroundColor: secondaryColor1,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: height * .02,
                ),
                Form(
                  key: formKey,
                  child: Expanded(
                    child: ListView(
                      children: [
                        Center(
                          child: SizedBox(
                            width: width * .8,
                            child: textFieldWidgetWithoutFilledCompany(
                              context: context,
                              controller: projectName,
                              hintText: 'project_name'.tr,
                              icons: const Icon(Icons.attribution),
                              obscureText: false,
                              type: TextInputType.text,
                              textValidatorEmpty:
                                  "please_enter_project_name".tr,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Center(
                          child: SizedBox(
                            width: width * .8,
                            child: textFieldWidgetWithoutFilledCompany(
                              context: context,
                              controller: name,
                              hintText: 'name'.tr,
                              icons: const Icon(Icons.portrait_outlined),
                              obscureText: false,
                              type: TextInputType.text,
                              textValidatorEmpty: "please_enter_name".tr,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        Center(
                            child: SizedBox(
                                width: width * .8,
                                child: TextFormField(
                                  maxLength: phoneNumberLength,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please_enter_phone_number'.tr;
                                    } else if (value.length < 10) {
                                      return 'phone_number_not_valid'.tr;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        phoneNumberLength = 10;
                                      });
                                    }
                                    phone.text = value.removeAllWhitespace;
                                    setState(() {
                                      phoneNumberLength = 10;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  controller: phone,
                                  style: const TextStyle(fontSize: 18.0),
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.phone_iphone),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    hintText: '0777477748',
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: secondaryColor1,
                                            width: 1.0)),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: secondaryColor1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: secondaryColor1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: secondaryColor1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ))),
                        SizedBox(height: height * .02),
                        Center(
                          child: SizedBox(
                            width: width * .8,
                            child: TextField(
                              controller: note,
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(fontSize: 18.0),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.note_outlined,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                hintText: 'notes'.tr,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: secondaryColor1, width: 1.0)),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: secondaryColor1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: secondaryColor1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: secondaryColor1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .05,
                        ),
                        Center(
                          child: SizedBox(
                            width: width * .7,
                            child: DropdownSearch<String>(
                              /*       dropdownSearchDecoration: const InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: secondaryColor1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: secondaryColor1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.only(right: 20, left: 20)),
                              popupBarrierColor: Colors.black.withOpacity(.5),
                              validator: (value) =>
                                  value == null ? 'please_enter_destination'.tr : null,
                              mode: Mode.DIALOG,
                              items: locations,
                              showSearchBox: true,
                              // ignore: deprecated_member_use
                              label: "select_destination".tr, */
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                label: Text("Select Destination"),
                              )),
                              validator: (value) => value == null
                                  ? 'please_enter_destination'.tr
                                  : null,
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                              ),
                              items: locations,
                              onChanged: (value) {
                                setState(() {
                                  destinationValue = value;
                                });
                              },
                              onSaved: (val) {},
                              filterFn: (instance, filter) {
                                if (instance.contains(filter)) {
                                  return true;
                                } else if (instance
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())) {
                                  return true;
                                } else {
                                  return false;
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * .02,
                        ),
                        isMultiLocation == true
                            ? Container()
                            : Center(
                                child: SizedBox(
                                  width: width * .7,
                                  child: DropdownSearch<String>(
                                    /*  dropdownSearchDecoration: const InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: secondaryColor1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: secondaryColor1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  contentPadding:
                                      EdgeInsets.only(right: 20, left: 20)),
                              popupBarrierColor: Colors.black.withOpacity(.5),
                              validator: (value) =>
                                  value == null ? 'please_choose_location'.tr : null,
                              mode: Mode.MENU,
                              items: const [
                                'One Way',
                                'One Location',
                                'Multi Location'
                              ],
                              showSearchBox: true,
                              // ignore: deprecated_member_use
                              label: "select_location".tr, */
                                    dropdownDecoratorProps:
                                        const DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                      label: Text("Select Location"),
                                    )),
                                    validator: (value) => value == null
                                        ? 'please_choose_location'.tr
                                        : null,
                                    popupProps: const PopupProps.menu(
                                      showSearchBox: true,
                                    ),
                                    items: const [
                                      'One Way',
                                      'One Location',
                                      'Multi Location'
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        locationValue = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: height * .02,
                        ),
                        ListView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            // padding: EdgeInsets.only(bottom: _height * .1),
                            itemCount: count,
                            itemBuilder: (context, i) {
                              return column(i);
                            }),
                        SizedBox(height: height * .03),
                        Center(
                          child: SizedBox(
                            width: width * .50,
                            height: height * .05,
                            // ignore: deprecated_member_use
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  mapMobile.clear();
                                  date.clear();
                                  jsonApiTotalPrice.clear();
                                  time.clear();
                                  webJson.clear();
                                });
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();

                                  for (var i = 0; i < count; i++) {
                                    setState(() {
                                      onUpdate(i);
                                    });
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  var sharedToken =
                                      prefs.getString('access_token_company');
                                  Map<String, dynamic> jsonApi = {
                                    'destination': destinationValue,
                                    'trips': isCompany.toString() == '1'
                                        ? 'myTrip'
                                        : locationValue,
                                    'vehicleType': widget.type,
                                    'numberOfTrips': count.toString(),
                                    'token': sharedToken,
                                    'mobile': '1'
                                  };

                                  String apiUrl =
                                      ApiApp.getTotalTransportationOrder;

                                  http.Response response = await http
                                      .post(Uri.parse(apiUrl), body: jsonApi);
                                  var jsonResponse = jsonDecode(response.body);
                                  Timer(const Duration(seconds: 3), () {
                                    push(
                                        context,
                                        DetailsOneTripCompany(
                                          webJson: webJson,
                                          mapMobile: mapMobile[0],
                                          itemCount: count,
                                          totalPrice:
                                              jsonResponse['totalPrice'],
                                          vechileType: widget.type,
                                          // mapWeb:mapWeb,
                                          phone: phone.text,
                                          projectName: projectName.text,
                                          name: name.text,
                                        ));

                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                }
                              },
                              child: Text(
                                'confirm'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: const Padding(
              padding: EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  
                ],
              ),
            ));
  }

  onUpdate(int entryIndex) async {
    date.add(dateController[entryIndex].text);
    time.add(
      timeController[entryIndex].text,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token_company');
    Map<String, dynamic> jsonApi = {
      'destination': destinationValue,
      'trips': isMultiLocation == true ? "Multi Location Way" : locationValue,
      'vehicleType': widget.type,
      'numberOfTrips': count.toString(),
      'token': sharedToken,
      'note': note.text,
      'mobile': '1'
    };
    String apiUrl = ApiApp.getTotalTransportationOrder;

    http.Response response = await http.post(Uri.parse(apiUrl), body: jsonApi);

    var jsonResponse = jsonDecode(response.body);

    Map<String, dynamic> json = {
      'Destination': destinationValue,
      'Location':
          isMultiLocation == true ? "Multi Location Way" : locationValue,
      // 'CustomerName':customerName,
      // 'CustomerNumber':customerNumber,
      // 'VehicleType': widget.type,
      'customerName': name.text,
      'phoneNumber': phone.text,
      'Date': date,
      'Time': time,
      'note': note.text,
      'price': jsonResponse['pricePerDay'],
      'currency': jsonResponse['currency']
    };

    // for (var i = 0; i < count; i++) {
    var obj = {
      'Destination': destinationValue,
      'Location':
          isMultiLocation == true ? "Multi Location Way" : locationValue,
      // 'CustomerName':customerName,
      // 'CustomerNumber':customerNumber,
      // 'VehicleType': widget.type,
      'customerName': name.text,
      'phoneNumber': phone.text,
      'Date': date[entryIndex],
      'Time': time[entryIndex],
      'note': note.text,
      'price': jsonResponse['pricePerDay'],
      'currency': jsonResponse['currency']
    };

    webJson.add(obj);
    // }
    // webJson.clear();
    // setState(() {
    mapMobile.add(json);
    // });
  }

  column(int index) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: height * .01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'trip'.tr + ' ${index + 1} :'.tr,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: width * .4,
              child: textFieldWidgetWithoutFilledWithFunction(
                  context: context,
                  hintText: "date".tr,
                  controller: dateController[index],
                  icons: const Icon(
                    Icons.calendar_today,
                  ),
                  fun: () {
                    selectDate(
                      context: context,
                      dateController: dateController[index],
                      selectedDate: DateTime.now(),
                      firstDate: DateTime.now(),
                    );
                  },
                  textValidatorEmpty: "please_enter_date".tr),
            ),
            SizedBox(
              width: width * .4,
              child: textFieldWidgetWithoutFilledWithFunctionSmall(
                context: context,
                fun: () {
                  selectTime(
                      context: context, timeController: timeController[index]);
                },
                icons: const Icon(Icons.access_time),
                controller: timeController[index],
                hintText: "time".tr,
                textValidatorEmpty: "please_enter_time".tr,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
