import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared/mehod/message.dart';
import '../shared/styles/colors.dart';

enum Location { dubai, jordan }

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String? destination;
  String? locationValue;
  // ignore: prefer_typing_uninitialized_variables
  var _located;
  bool isLocationAmman = false;
  bool isLocationDubai = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => showPopup(
          context: context,
          question: "Are you sure to exit ?".tr,
          funReject: () {
            Navigator.pop(context);
          },
          funAccept: () {
            exit(0);
          }),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'LYON',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          backgroundColor: secondaryColor1,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: _height * .02,
              ),
              Text(
                'select_country'.tr,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              //     SizedBox(
              //   height: MediaQuery.of(context).size.height*.2,
              //   width: MediaQuery.of(context).size.width,
              //   child: CarouselSlider.builder(
              //     unlimitedMode: true,
              //     autoSliderDelay: const Duration(seconds: 3),
              //     keepPage: true,
              //     enableAutoSlider: true,
              //     autoSliderTransitionTime: const Duration(seconds: 2),
              //     itemCount: 8,
              //     slideBuilder: (int index) => Image.asset(
              //       "assets/images/image$index.png",
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              RadioListTile<Location>(
                title: const Text('Jordan - Amman'),
                value: Location.jordan,
                groupValue: _located,
                onChanged: (Location? value) {
                  setState(() {
                    _located = value!;
                    if (_located == Location.jordan) {
                      setState(() {
                        destination = 'Amman';
                        isLocationAmman = true;
                        isLocationDubai = false;
                      });
                    }
                  });
                  // print(destination);
                },
              ),
              Visibility(
                visible: isLocationAmman,
                child: Center(
                  child: SizedBox(
                    width: _width * .7,
                    child: DropdownSearch<String>(
                      dropdownButtonProps:
                          const DropdownButtonProps(color: secondaryColor1),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                          textAlignVertical: TextAlignVertical.center,
                          dropdownSearchDecoration: InputDecoration(
                            label: Text("Select location"),
                          )),

                      //popupProps: const PopupProps.menu(),
                      //  dropdownSearchDecoration: const InputDecoration(
                      //           errorBorder: OutlineInputBorder(
                      //               borderSide: BorderSide(color: secondaryColor1),
                      //               borderRadius:
                      //                   BorderRadius.all(Radius.circular(10))),
                      //           border: InputBorder.none,
                      //           enabledBorder: OutlineInputBorder(
                      //               borderSide: BorderSide(color: secondaryColor1),
                      //               borderRadius:
                      //                   BorderRadius.all(Radius.circular(10))),
                      //           contentPadding:
                      //               EdgeInsets.only(right: 20, left: 20)),
                      // popupBarrierColor: Colors.black.withOpacity(.5),
                      validator: (value) =>
                          value == null ? 'please choose location' : null,
                      // mode: Mode.MENU,
                      items: const [
                        'Amman',
                        'Queen Alia Airport',
                        'King Hussien Bridge'
                      ],
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                      ),
                      // showSearchBox: true,
                      // ignore: deprecated_member_use
                      //label: "Select Location",
                      onChanged: (value) {
                        setState(() {
                          locationValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),

              RadioListTile<Location>(
                title: const Text('UAE - Dubai'),
                value: Location.dubai,
                groupValue: _located,
                onChanged: (Location? value) {
                  setState(() {
                    _located = value!;
                    if (_located == Location.dubai) {
                      setState(() {
                        destination = 'Dubai';
                        isLocationAmman = false;
                        isLocationDubai = true;
                      });
                    }
                  });
                  // print(destination);
                },
              ),
              Visibility(
                visible: isLocationDubai,
                child: Center(
                  child: SizedBox(
                    width: _width * .7,
                    child: DropdownSearch<String>(
                      /*   dropdownSearchDecoration: const InputDecoration(
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
                                value == null ? 'please choose location' : null,
                            mode: Mode.MENU,
                            items: const ['Dubai', 'Dubai Airport'],
                            showSearchBox: true,
                            // ignore: deprecated_member_use
                            label: "Select Location", */
                      dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                        label: Text("Select Location"),
                      )),
                      validator: (value) =>
                          value == null ? 'please choose location' : null,
                      onChanged: (value) {
                        setState(() {
                          locationValue = value;
                        });
                      },
                    ),
                  ),
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
                      'continue'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _located != null) {
                        print(destination);
                        print(locationValue);
                      } else {
                        print('please check destination and location');
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
