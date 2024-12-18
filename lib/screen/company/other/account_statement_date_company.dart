import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/v_done/utils/custom_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/Widgets/text_field_widget.dart';
import '../../../shared/styles/colors.dart';
import 'account_statement_details_company.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AccountStatementDateCompany extends StatefulWidget {
  String? accountType;
  AccountStatementDateCompany({super.key, this.accountType});

  @override
  State<AccountStatementDateCompany> createState() =>
      _AccountStatementDateCompanyState();
}

class _AccountStatementDateCompanyState
    extends State<AccountStatementDateCompany> {
  TextEditingController firstDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? firstController;
  DateTime? secondController;
  final _formKey = GlobalKey<FormState>();
  bool isLaoding = true;
  String? projectNameClicked;

  Future<void> _selectDateFirst(
      {required BuildContext context,
      required TextEditingController dateController,
      selectedDate,
      firstDate,
      lastDate}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 1),
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

  List<String> projectsName = [];
  getProjectsName() async {
    // String apiUrl = ApiApp.getProjectName;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('access_token_company');
    logInfo(token.toString());
    http.Response response = await http.post(
        Uri.parse('https://lyon-jo.com/api/GetProjectName.php'),
        body: {"token": token, "mobile": "1"});
    var jsonResponse = jsonDecode(response.body);
    projectsName.add('All');

    for (var i = 0; i < jsonResponse.length; i++) {
      projectsName.add(jsonResponse[i]['project_name']);
    }
  }

  @override
  void initState() {
    getProjectsName().then((value) {
      if (mounted) {
        setState(() {
          isLaoding = false;
        });
      }
    });

    super.initState();
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
        lastDate: selectedDate.add(const Duration(days: 365)),
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

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: isLaoding
          ? const Scaffold(
              body: Center(
              child: CircularProgressIndicator(),
            ))
          : Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('account_statment'.tr),
                backgroundColor: secondaryColor1,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: _height * .1,
                    ),
                    Image.asset(
                      "assets/images/logo.png",
                      width: _width * .5,
                    ),
                    SizedBox(
                      height: _height * .02,
                    ),
                    Center(
                      child: SizedBox(
                        width: _width * .8,
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
                      height: _height * .02,
                    ),
                    Center(
                      child: SizedBox(
                        width: _width * .8,
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
                      height: _height * .02,
                    ),
                    SizedBox(
                      width: _width * .8,
                      child: DropdownSearch<String>(
                        /*  dropdownSearchDecoration: const InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    contentPadding: EdgeInsets.only(right: 20, left: 20)),
                popupBarrierColor: Colors.black.withOpacity(.5),
                validator: (value) =>
                    value == null ? 'enter_project_name'.tr : null,
                mode: Mode.DIALOG,
                items: projectsName,
                showSearchBox: true,
                // ignore: deprecated_member_use
                label:
                        "select_project_name".tr, */
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                          label: Text("Select Project Name"),
                        )),
                        items: projectsName,
                        validator: (value) =>
                            value == null ? 'enter_project_name'.tr : null,
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            projectNameClicked = val;
                          });
                        },
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
                    SizedBox(
                      height: _height * .05,
                    ),
                    SizedBox(
                        width: _width * .50,
                        height: _height * .05,
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
                          onPressed: () {
                            if (firstDateController.text.isNotEmpty &&
                                endDateController.text.isEmpty) {
                              _formKey.currentState!.validate();
                            } else {
                              if (_formKey.currentState!.validate()) {
                                push(
                                    context,
                                    AccountStatementDetailsCompany(
                                        projectName: projectNameClicked,
                                        dateFrom: firstDateController.text,
                                        dateTo: endDateController.text,
                                        accountType: widget.accountType));
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
