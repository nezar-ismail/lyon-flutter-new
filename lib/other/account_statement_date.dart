import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import '../shared/Widgets/text_field_widget.dart';
import '../shared/styles/colors.dart';
import 'account_statement_details.dart';

// ignore: must_be_immutable
class AccountStatementDate extends StatefulWidget {
  String? accountType;
  AccountStatementDate({super.key, this.accountType});

  @override
  State<AccountStatementDate> createState() => _AccountStatementDateState();
}

class _AccountStatementDateState extends State<AccountStatementDate> {
  TextEditingController firstDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? firstController;
  DateTime? secondController;
  final _formKey = GlobalKey<FormState>();
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child:Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('account_statment'.tr),
          backgroundColor: secondaryColor1,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .1,
              ),
              Image.asset(
                "assets/images/logo.png",
                width: width * .5,
              ),
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
                        ),),
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
                              AccountStatementDetails(
                                  dateFrom: firstDateController.text,
                                  dateTo: endDateController.text,
                                  accountType: widget.accountType)
                                  );
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
