// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'details_full_day_company.dart';

class FullDayProgramCompany extends StatefulWidget {
  const FullDayProgramCompany({super.key});

  @override
  State<FullDayProgramCompany> createState() => _FullDayProgramCompanyState();
}

class _FullDayProgramCompanyState extends State<FullDayProgramCompany> {
  TextEditingController firstDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController projectName = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  String numberVechile = '1';
  DateTime? firstController;
  DateTime? secondController;
  final _formKey = GlobalKey<FormState>();
  String vechileType = '';
  bool isLoading = true;

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

  List<String> vechileTypeDataBase = [];
  List vechileTypePriceLess3 = [];
  List vechileTypePriceMore3 = [];
  getVechileType() async {
    String apiUrl = ApiApp.getCompanyFullDayPrice;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('access_token_company');
    http.Response response = await http
        .post(Uri.parse(apiUrl), body: {"token": token, "mobile": "1"});
    var jsonResponse = jsonDecode(response.body);
    for (var item in jsonResponse) {
      vechileTypeDataBase.add(item['Vehicle']);
      vechileTypePriceLess3.add(item['Price_Less_3']);
      vechileTypePriceMore3.add(item['Price_More_3']);
    }
  }

  @override
  void initState() {
    getVechileType();
    getVechileType().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('full_day_program'.tr),
        centerTitle: true,
        backgroundColor: secondaryColor1,
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .05,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * .8,
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
                              value == null ? 'please_choose_vehicle_2'.tr : null,
                          mode: Mode.MENU,
                          items: vechileTypeDataBase,
                          showSearchBox: true,
                          // ignore: deprecated_member_use
                          label: "select_vehicle".tr, */
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                            label: Text("Select vehicle"),
                          )),
                          items: const ['Elantra', 'mini-van'],
                          validator: (value) => value == null
                              ? 'please_choose_vehicle_2'.tr
                              : null,
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              vechileType = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * .8,
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
                              value == null ? 'please_choose_vehicle_2'.tr : null,
                          mode: Mode.MENU,
                          items:const ['1','2','3','4','5','6','7','8','9','10'],
                          showSearchBox: true,
                          // ignore: deprecated_member_use
                          label: "number_of_vehicle".tr, */
                          dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                            label: Text("Number of vehicle"),
                          )),
                          items: const [
                            '1',
                            '2',
                            '3',
                            '4',
                            '5',
                            '6',
                            '7',
                            '8',
                            '9',
                            '10'
                          ],
                          validator: (value) => value == null
                              ? 'please_choose_vehicle_2'.tr
                              : null,
                          onChanged: (value) {
                            setState(() {
                              numberVechile = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * .8,
                        child: textFieldWidgetWithoutFilled(
                          context: context,
                          controller: projectName,
                          hintText: 'project_name'.tr,
                          icons: const Icon(Icons.attribution),
                          obscureText: false,
                          type: TextInputType.text,
                          textValidatorEmpty: "please_enter_project_name".tr,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * .8,
                        child: textFieldWidgetWithoutFilled(
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
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please_enter_phone_number'.tr;
                                } else if (value.length < 10) {
                                  return 'phone_number_not_valid'.tr;
                                }
                                return null;
                              },
                              controller: phone,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
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
                            ))),
                    SizedBox(
                      height: height * .02,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * .8,
                        child: textFieldWidgetWithoutFilledWithFunctionSmall(
                          context: context,
                          fun: () {
                            setState(() {
                              endDateController.text = '';
                            });
                            _selectDateFirst(
                              context: context,
                              dateController: firstDateController,
                              selectedDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime((DateTime.now().year) + 3, 12),
                            );
                          },
                          icons: const Icon(Icons.calendar_today),
                          controller: firstDateController,
                          hintText: "start_date".tr,
                          textValidatorEmpty: "please_enter_start_date".tr,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * .8,
                        child: textFieldWidgetWithoutFilledWithFunctionSmall(
                          context: context,
                          fun: firstController == null
                              ? () {}
                              : () {
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
                          hintText: "end_date".tr,
                          textValidatorEmpty: "please_enter_end_date".tr,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                    SizedBox(
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
                          child: Text(
                            'continue'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (firstDateController.text.isNotEmpty &&
                                endDateController.text.isEmpty) {
                              _formKey.currentState!.validate();
                            } else {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                var sharedToken =
                                    prefs.getString('access_token_company');
                                Map<String, dynamic> json = {
                                  // 'phone': phone.text,
                                  // 'name': name.text,
                                  'VehicleType': vechileType,
                                  'token': sharedToken,
                                  'mobile': '1',
                                  'startDate': firstDateController.text,
                                  'endDate': endDateController.text,
                                  'VehicleNumber': numberVechile
                                };

                                String apiUrl = ApiApp.getCompanyFullDayPrice;

                                http.Response response = await http
                                    .post(Uri.parse(apiUrl), body: json)
                                    .whenComplete(() => setState(() {
                                          isLoading = false;
                                        }));

                                var jsonResponse = jsonDecode(response.body);
                                push(
                                    context,
                                    DetailsFullDayCompany(
                                        customerName: name.text,
                                        endDate: endDateController.text,
                                        phoneNumber: phone.text,
                                        projectName: projectName.text,
                                        startDate: firstDateController.text,
                                        vehicleName: vechileType,
                                        totalPrice: jsonResponse['TotalPrice'],
                                        pricePerDay:
                                            jsonResponse['PricePerDay'],
                                        currency: jsonResponse['currency'],
                                        vehicleimage:
                                            jsonResponse['VehiclePathimage'],
                                        numberOfDay:
                                            jsonResponse['NumberOfDay'],
                                        numberVechile: numberVechile));
                              }
                            }
                          },
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}
