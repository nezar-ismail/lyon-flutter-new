import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lyon/screen/company/trip_company/selecte_one_trip_company.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';

import '../../../shared/styles/colors.dart';
import '../../../v_done/company/trip_form/views/selecte_multe_trip_company.dart';

class TripHomePageCompany extends StatefulWidget {
  final String? image;
  final String? type;
  final String? numberTrip;
  const TripHomePageCompany({super.key, this.image, this.type, this.numberTrip});

  @override
  State<TripHomePageCompany> createState() => _TripHomePageCompanyState();
}

class _TripHomePageCompanyState extends State<TripHomePageCompany> {
  String vehicleType = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController projectName = TextEditingController();

  @override
  void initState() {
    super.initState();
    //  numberTrip = TextEditingController(text: '1');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor1,
          title: Text(
            'tourism_program'.tr,
            style: const TextStyle(color: secondaryColor1, fontSize: 25),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .03,
              ),
              SizedBox(
                height: height * .02,
              ),
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
                        maxLength: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please_enter_phone_number'.tr;
                          } else if (value.length < 10) {
                            return 'phone_number_not_valid'.tr;
                          }
                          return null;
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.numberTrip == '1') {
                          push(
                              context,
                              SelecteOneTripCompany(
                                type: widget.type ?? 'Car',
                                numTrip: widget.numberTrip ?? '1',
                                image: 'assets/images/Van2.png',
                              ));
                        } else {
                          push(
                              context,
                              SelecteMulteTripCompany(
                                type: widget.type ?? 'Car',
                              ));
                        }
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

