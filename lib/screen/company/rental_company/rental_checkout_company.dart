import 'dart:io';
import 'package:dio/dio.dart' as prefix;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import '../../../shared/Widgets/text_field_widget.dart';
import '../../../shared/styles/colors.dart';
import 'rental_create_order_company.dart';

// ignore: must_be_immutable
class RentalCheckOutCompany extends StatefulWidget {
  String carImage;
  String carId;
  String id;
  String vehicleName;
  RentalCheckOutCompany(
      {super.key,
      required this.id,
      required this.carImage,
      required this.carId,
      required this.vehicleName});

  @override
  State<RentalCheckOutCompany> createState() => _RentalCheckOutCompanyState();
}

class _RentalCheckOutCompanyState extends State<RentalCheckOutCompany> {
  TextEditingController firstDateController = TextEditingController();
  TextEditingController firstTimeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController projectName = TextEditingController();
  DateTime? firstController;
  DateTime? secondController;
  final _formKey = GlobalKey<FormState>();
  late String time;
  bool isCheckLicense = false;
  bool isVisibleLicense = true;
  bool isUploadLicenseSuccess = false;
  final ImagePicker _imagePicker = ImagePicker();
  File? image1;
  bool isLastItem = false;
  bool isImageNull = false;
  var dio = prefix.Dio();
  // bool isLoadingButton = false;

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
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      setState(() {
        timeController.text = pickedTime.format(context);
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
      String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
      setState(() {
        timeController.text = pickedTime.format(context);
      });
    }
  }

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
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: secondaryColor1,
          title: Text('rental'.tr,
              style: const TextStyle(color: Colors.white, fontSize: 25)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(height: _height*.1,),
              Image.network(
                widget.carImage,
                // "assets/images/logo.png",
                width: _width * .5,
              ),
              SizedBox(
                height: _height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: textFieldWidgetWithoutFilledWithFunctionSmall(
                      context: context,
                      fun: () {
                        _selectTimeFirst(
                            context: context,
                            timeController: firstTimeController);
                      },
                      icons: const Icon(Icons.access_time),
                      controller: firstTimeController,
                      hintText: "start_time".tr,
                      textValidatorEmpty: "please_enter_start_time".tr,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: textFieldWidgetWithoutFilledWithFunctionSmall(
                      context: context,
                      fun: () {
                        _selectTimeSecond(
                            context: context,
                            timeController: endTimeController);
                      },
                      icons: const Icon(Icons.access_time),
                      controller: endTimeController,
                      hintText: "end_time".tr,
                      textValidatorEmpty: "please_enter_end_time".tr,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _height * .05,
              ),
              Center(
                child: SizedBox(
                  width: _width * .8,
                  child: textFieldWidgetWithoutFilledCompany(
                    context: context,
                    controller: projectName,
                    capitalLowercase: TextCapitalization.none,
                    hintText: 'project_name'.tr,
                    icons: const Icon(Icons.attribution),
                    obscureText: false,
                    type: TextInputType.text,
                    textValidatorEmpty: "please_enter_project_name".tr,
                  ),
                ),
              ),
              SizedBox(
                height: _height * .02,
              ),
              Center(
                child: SizedBox(
                  width: _width * .8,
                  child: textFieldWidgetWithoutFilledCompany(
                    context: context,
                    controller: name,
                    hintText: 'name'.tr,
                    capitalLowercase: TextCapitalization.none,
                    icons: const Icon(Icons.portrait_outlined),
                    obscureText: false,
                    type: TextInputType.text,
                    textValidatorEmpty: "please_enter_name".tr,
                  ),
                ),
              ),
              SizedBox(
                height: _height * .02,
              ),
              Center(
                  child: SizedBox(
                      width: _width * .8,
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
                        keyboardType: const TextInputType.numberWithOptions(
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
                height: _height * .02,
              ),
              GestureDetector(
                  onTap: () {
                    !isLastItem || image1 == null
                        ? const Text("")
                        : _viewOrDeleteImage(image1!);
                  },
                  child: !isLastItem || image1 == null
                      ? GestureDetector(
                          onTap: () => _pickImage(),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            width: MediaQuery.of(context).size.width * .8,
                            height: MediaQuery.of(context).size.height / 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                                Text('license_image'.tr),
                              ],
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.file(
                            image1!,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * .8,
                            height: MediaQuery.of(context).size.height / 4,
                          ),
                        )),

              Visibility(
                visible: isImageNull,
                child: Text(
                  'please_upload_image'.tr,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(
                height: _height * .02,
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
                      'continue'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (firstDateController.text.isNotEmpty &&
                          endDateController.text.isEmpty) {
                        _formKey.currentState!.validate();
                      } else if (_formKey.currentState!.validate() &&
                          image1 != null) {
                        push(
                            context,
                            RentalCreateOrderCompany(
                                id: widget.id,
                                carId: widget.carId,
                                startDate: firstDateController.text,
                                startTime: firstTimeController.text,
                                endDate: endDateController.text,
                                endTime: endTimeController.text,
                                customerName: name.text,
                                projectName: projectName.text,
                                phoneNumber: phone.text,
                                licenseImage: image1,
                                vehicleName: widget.vehicleName.toString(),
                                carImage: widget.carImage));
                      } else if (image1 == null) {
                        setState(() {
                          isImageNull = true;
                        });
                      } else {
                        setState(() {
                          isImageNull = false;
                        });
                      }
                    },
                  )),
              SizedBox(
                height: _height * .04,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _viewOrDeleteImage(File? imageFile) {
    final action = CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () async {
            setState(() {
              imageFile = null;
              isLastItem = false;
            });
            Navigator.pop(context);
          },
          child: Text('delete_photo'.tr),
          isDestructiveAction: true,
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('cancel'.tr),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _pickImage() {
    final action = CupertinoActionSheet(
      message: Text(
        'add_image'.tr,
        style: const TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('choose_image_gallery'.tr),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                isLastItem = true;
                image1 = File(image.path);
              });
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text('choose_image'.tr),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null) {
              setState(() {
                isLastItem = true;
                image1 = File(image.path);
              });
            }
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('cancel'.tr),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
