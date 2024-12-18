// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:lyon/api/api.dart';
// import 'package:lyon/model/company_model/trips_model.dart';
// import 'package:lyon/screen/company/trip_company/details_multi_trip_company.dart';
// import 'package:lyon/shared/Widgets/button.dart';
// import 'package:lyon/shared/Widgets/text_field_widget.dart';
// import 'package:lyon/shared/mehod/switch_sreen.dart';
// import 'package:lyon/shared/styles/colors.dart';
// import 'package:http/http.dart' as http;
// import 'package:lyon/v_done/utils/custom_log.dart';
// import 'package:lyon/v_done/utils/custom_snackbar.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SelecteMulteTripCompany extends StatefulWidget {
//   final String type;
//   final String numTrip;
//   const SelecteMulteTripCompany({
//     super.key,
//     required this.type,
//     required this.numTrip,
//   });
//   @override
//   State<SelecteMulteTripCompany> createState() =>
//       _SelecteMulteTripCompanyState();
// }

// class _SelecteMulteTripCompanyState extends State<SelecteMulteTripCompany> {
//   List<Map<String, dynamic>> mapMobile = [];
//   int numberOfTrips = 1;
//   int phoneNumberLength = 20;
//   int activeStep = 0;
//   int activeStep2 = 0;
//   int reachedStep = 0;
//   int upperBound = 5;
//   double progress = 0;
//   String? tripPrice;
//   String? tripCurrency;
//   List<ListElement> trips = [ListElement()];
//   Set<int> reachedSteps = <int>{};
//   TextEditingController projectName = TextEditingController();
//   double totalTripsPrice = 0.0;
//   List<String> directLocation = ['One Way', 'One Location', 'Multi Location'];
//   List directLocation2 = [];
//   List<TextEditingController> dateController =
//       List.generate(9, (i) => TextEditingController());
//   List<TextEditingController> timeController =
//       List.generate(9, (i) => TextEditingController());
//   List<TextEditingController> locationController =
//       List.generate(9, (i) => TextEditingController());
//   List<TextEditingController> customerNameController =
//       List.generate(9, (i) => TextEditingController());
//   List<TextEditingController> customerNumberController =
//       List.generate(9, (i) => TextEditingController());
//   List<TextEditingController> notesController =
//       List.generate(9, (i) => TextEditingController());
//   List<String?> customerDestinations = List.generate(9, (i) => '');
//   List<String> customerLocations = List.generate(9, (i) => '');
//   List<String> pricePerDay = List.generate(9, (i) => '');
//   List<String> currencies = List.generate(9, (i) => '');
//   bool isLoading = true;
//   bool isTripPriceLoading = false;
//   bool isComplete = false;
//   int isCompany = 0;
//   Future<void> selectDate({
//     required BuildContext context,
//     required TextEditingController dateController,
//     selectedDate,
//     firstDate,
//   }) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: firstDate,
//         lastDate: DateTime((DateTime.now().year) + 3, 12),
//         errorInvalidText: "Out of range");
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         dateController.text =
//             "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
//       });
//     }
//   }

//   Future<void> selectTime(
//       {required BuildContext context,
//       required TextEditingController timeController}) async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       initialTime: TimeOfDay.now(),
//       context: context,
//     );
//     if (pickedTime != null) {
//       DateTime parsedTime =
//           DateFormat.Hm().parse(pickedTime.format(context).toString());
//       DateFormat('HH:mm').format(parsedTime);
//       setState(() {
//         timeController.text = pickedTime.format(context);
//       });
//     }
//   }

//   List<String> locations = [];
//   var isMultiLocation = false;
//   getTransportationRoutes() async {
//     String apiUrl = ApiApp.getAllCompanyTransportations;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = prefs.getString('access_token_company');
//     http.Response response = await http
//         .post(Uri.parse(apiUrl), body: {"token": token, "mobile": "1"});
//     var jsonResponse = jsonDecode(response.body);
//     logInfo("conmpany routes [Transportations] >>>>>>>>>>>>> ${response.body}");
//     for (var i = 0; i < jsonResponse.length; i++) {
//       if (jsonResponse[i]['location'] == null) {
//         setState(() {
//           isMultiLocation = true;
//         });
//         locations.add(jsonResponse[i]['locations']);
//       } else {
//         locations.add(jsonResponse[i]['location']);
//       }
//     }
//   }

//   Future<String> checkCompanyType() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var sharedToken = prefs.getString('access_token_company');
//     logInfo(sharedToken.toString());
//     var response = await http.post(
//         Uri.parse("https://lyon-jo.com/api/checkCompanyTypeTrip.php"),
//         body: {
//           'token': sharedToken.toString(),
//         });
//         logInfo("conmpany routes [checkCompanyTypeTrip] >>>>>>>>>>>>> ${response.body}");
//     var jsonResponse = jsonDecode(response.body);
//     if (jsonResponse["status"] == 200) {
//       setState(() {
//         isCompany = int.parse(jsonResponse["message"]);
//       });
//     }
//     return jsonResponse["message"];
//   }

//   checkUserDocuments() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var sharedToken = prefs.getString('access_token');
//     String apiUrl = ApiApp.checkUserDocuments;
//     final json = {"token": sharedToken, "mobile": "1"};
//     http.Response response = await http.post(Uri.parse(apiUrl), body: json);
//     var jsonResponse = jsonDecode(response.body);
//     logInfo("conmpany routes [checkUserDocuments] >>>>>>>>>>>>> $jsonResponse");

//     return jsonResponse;
//   }

//   final List<GlobalKey<FormState>> formKeys =
//       List.generate(9, (i) => GlobalKey<FormState>());
//   @override
//   void initState() {
//     checkCompanyType();
//     getTransportationRoutes().then((value) {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     });
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     progress = 1 / numberOfTrips;
//     dateController = List.generate(11, (i) => TextEditingController());
//     timeController = List.generate(11, (i) => TextEditingController());
//     locationController = List.generate(11, (i) => TextEditingController());
//     customerNameController = List.generate(11, (i) => TextEditingController());
//     customerNumberController =
//         List.generate(11, (i) => TextEditingController());
//     notesController = List.generate(11, (i) => TextEditingController());
//     customerDestinations = List.generate(11, (i) => '');
//     customerLocations = List.generate(11, (i) => '');
//     pricePerDay = List.generate(11, (i) => '');
//     currencies = List.generate(11, (i) => '');
//     super.initState();
//   }

//   @override
//   dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     projectName.dispose();
//     for (var controller in dateController) {
//       controller.dispose();
//     }
//     for (var controller in timeController) {
//       controller.dispose();
//     }
//     for (var controller in locationController) {
//       controller.dispose();
//     }
//     for (var controller in customerNameController) {
//       controller.dispose();
//     }
//     for (var controller in customerNumberController) {
//       controller.dispose();
//     }
//     for (var controller in notesController) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     return isLoading
//         ? Scaffold(
//             resizeToAvoidBottomInset: false,
//             body: Center(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const CircularProgressIndicator(
//                   color: secondaryColor1,
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 isComplete
//                     ? Column(
//                         children: [
//                           Text(
//                             "we_are_calculation_your_trips_price".tr,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       )
//                     : const SizedBox(),
//               ],
//             )),
//           )
//         : Scaffold(
//             backgroundColor: Colors.white,
//             appBar: PreferredSize(
//                 preferredSize: const Size.fromHeight(82),
//                 child: AppBar(
//                   backgroundColor: secondaryColor1,
//                   elevation: 0,
//                   centerTitle: true,
//                   foregroundColor: Colors.white,
//                   title: const Text("Tourism Program"),
//                   leading: IconButton(
//                       onPressed: () {
//                         Get.defaultDialog(
//                           title: "Are You Sure You want to Cancel",
//                           content: const Text("You will lose all data"),
//                           confirm: buttonSmall(
//                               context: context,
//                               text: 'confirm',
//                               function: () {
//                                 Get.back(closeOverlays: true);
//                               }),
//                           cancel: buttonSmall(
//                               context: context,
//                               text: 'cancel',
//                               function: () {
//                                 Get.back();
//                               }),
//                         );
//                       },
//                       icon: const Icon(Icons.arrow_back)),
//                 )),
//             body: Column(
//               children: [
//                 EasyStepper(
//                   steppingEnabled: false,
//                   lineStyle: const LineStyle(
//                     lineType: LineType.dashed,
//                   ),
//                   enableStepTapping: false,
//                   activeStep: activeStep,
//                   direction: Axis.horizontal,
//                   unreachedStepIconColor: Colors.white,
//                   unreachedStepBorderColor: Colors.black54,
//                   finishedStepBackgroundColor: const Color(0xff2a64ad),
//                   unreachedStepBackgroundColor: const Color(0xffefcf14),
//                   showTitle: true,
//                   onStepReached: (index) {
//                     logInfo(formKeys.length.toString());
//                     if (activeStep == 0) {
//                       setState(() => activeStep = index);
//                     }
//                     logInfo("activeStep : $activeStep");
//                     formKeys[activeStep].currentState!.validate();
//                     setState(() => activeStep = index);

//                     logInfo('Step $index reached');
//                   },
//                   steps: [
//                     const EasyStep(
//                       icon: Icon(CupertinoIcons.info_circle_fill),
//                       title: 'Project\n Name',
//                       customTitle: Center(
//                           child: Text(
//                         'Project\n Name',
//                         style: TextStyle(color: Color(0xff2a64ad)),
//                         textAlign: TextAlign.center,
//                       )),
//                       activeIcon: Icon(CupertinoIcons.cart),
//                     ),
//                     for (int i = 0; i < trips.length; i++)
//                       EasyStep(
//                         icon: const Icon(CupertinoIcons.map_pin_ellipse),
//                         title: 'Trip ${i + 1}',
//                         customTitle: Center(
//                           child: Text(
//                             'Trip ${i + 1}\nDetails',
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(color: Color(0xff2a64ad)),
//                           ),
//                         ),
//                         activeIcon: const Icon(CupertinoIcons.map_pin_ellipse),
//                       ),
//                   ],
//                 ),
//                 activeStep == 0
//                     ? Expanded(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: textFieldWidgetWithoutFilled(
//                                   context: context,
//                                   hintText: "project_name".tr,
//                                   obscureText: false,
//                                   type: TextInputType.text,
//                                   controller: projectName,
//                                   textValidatorEmpty:
//                                       'please_enter_project_name'.tr,
//                                   icons: const Icon(Icons.pageview)),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 _nextStep(StepEnabling.sequential),
//                               ],
//                             ),
//                           ],
//                         ),
//                       )
//                     : Expanded(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               columnOfData(activeStep),
//                               activeStep != 0
//                                   ? Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         _previousStep(StepEnabling.sequential),
//                                         _nextStep(StepEnabling.sequential),
//                                       ],
//                                     )
//                                   : const SizedBox(),
//                               activeStep != 0
//                                   ? Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         ElevatedButton(
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: secondaryColor1,
//                                               shape:
//                                                   const RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.all(
//                                                   Radius.circular(10),
//                                                 ),
//                                               ),
//                                             ),
//                                             onPressed: () {
//                                               if (formKeys[activeStep]
//                                                   .currentState!
//                                                   .validate()) {
//                                                 sendInfo();
//                                               }
//                                             },
//                                             child: Text(
//                                               'continue'.tr,
//                                               style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 20),
//                                             )),
//                                         trips.length > 1
//                                             ? Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 10.0),
//                                                 child: ElevatedButton(
//                                                     style: ElevatedButton
//                                                         .styleFrom(
//                                                       backgroundColor:
//                                                           Colors.red,
//                                                       shape:
//                                                           const RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius.all(
//                                                           Radius.circular(10),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     onPressed: () async {
//                                                       _delete();
//                                                       await onUpdate(
//                                                           activeStep,
//                                                           customerLocations[
//                                                               activeStep]);
//                                                     },
//                                                     child: Text(
//                                                       'delete'.tr,
//                                                       style: const TextStyle(
//                                                           color: Colors.white,
//                                                           fontSize: 20),
//                                                     )),
//                                               )
//                                             : const SizedBox()
//                                       ],
//                                     )
//                                   : const SizedBox(),
//                             ],
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           );
//   }

//   void _delete() {
//     return setState(() {
//       logWarning("activeStep : $activeStep");
//       logWarning("activeStep2 : $activeStep2");
//       logWarning("trips : ${trips.length}");
//       trips.removeAt(activeStep - 1);
//       formKeys.removeAt(activeStep);
//       customerDestinations[activeStep] = '';
//       customerLocations[activeStep] = '';
//       dateController[activeStep].value = const TextEditingValue();
//       timeController[activeStep].value = const TextEditingValue();
//       customerNameController[activeStep].value = const TextEditingValue();
//       customerNumberController[activeStep].value = const TextEditingValue();
//       notesController[activeStep].value = const TextEditingValue();
//       --activeStep;
//       --activeStep2;
//     });
//   }

//   Widget columnOfData(int index) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Form(
//       key: formKeys[index],
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(right: width * .1, left: width * .1),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: secondaryColor1),
//                 ),
//                 child: DropdownSearch<String>(
//                   dropdownDecoratorProps: const DropDownDecoratorProps(
//                       dropdownSearchDecoration: InputDecoration(
//                     hintText: "Select Destination",
//                   )),
//                   items: locations,
//                   selectedItem: customerDestinations[index] == '' ||
//                           customerDestinations[index] == null
//                       ? null
//                       : customerDestinations[index],
//                   validator: (value) =>
//                       value == null ? 'please_enter_destination'.tr : null,
//                   popupProps: const PopupProps.menu(
//                     showSearchBox: true,
//                   ),
//                   onSaved: (val) {},
//                   onChanged: (val) async {
//                     setState(() {
//                       customerDestinations[index] = val;
//                     });
//                     if (customerLocations[index] != '') {
//                       await onUpdate(index, customerLocations[index]);
//                     }
//                   },
//                   filterFn: (instance, filter) {
//                     if (instance.contains(filter)) {
//                       return true;
//                     } else if (instance
//                         .toLowerCase()
//                         .contains(filter.toLowerCase())) {
//                       return true;
//                     } else {
//                       return false;
//                     }
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: height * .02,
//               ),
//               isCompany.toString() == '1'
//                   ? const SizedBox()
//                   : Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: secondaryColor1),
//                       ),
//                       child: DropdownSearch<String>(
//                         dropdownDecoratorProps: const DropDownDecoratorProps(
//                             dropdownSearchDecoration: InputDecoration(
//                           hintText: "Select trip type",
//                         )),
//                         selectedItem: customerLocations[index] == ''
//                             ? null
//                             : customerLocations[index],
//                         validator: (value) =>
//                             value == null ? 'please_choose_location'.tr : null,
//                         popupProps: const PopupProps.menu(
//                           showSearchBox: true,
//                         ),
//                         onSaved: (val) {},
//                         onChanged: (val) async {
//                           setState(() {
//                             customerLocations[index] = val!;
//                           });
//                           if (customerDestinations[index] != '') {
//                             await onUpdate(index, customerLocations[index]);
//                           }
//                         },
//                         items: const [
//                           'One Way',
//                           'One Location',
//                           'Multi Location'
//                         ],
//                       ),
//                     ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//                   tripPrice == null ||
//                           customerDestinations[index] == '' ||
//                           customerLocations[index] == ''
//                       ? const Icon(Icons.info)
//                       : isTripPriceLoading == true
//                           ? SizedBox(
//                               height: height * .02,
//                               width: height * .02,
//                               child: const CircularProgressIndicator())
//                           : Text(
//                               "${"price".tr} : ${tripPrice ?? ""} ${tripCurrency ?? ""}",
//                             )
//                 ]),
//               ),
//               SizedBox(
//                 height: height * .02,
//               ),
//               textFieldWidgetWithoutFilledWithFunction(
//                   context: context,
//                   hintText: "date".tr,
//                   controller: dateController[index],
//                   icons: const Icon(
//                     Icons.calendar_today,
//                   ),
//                   fun: () {
//                     selectDate(
//                       context: context,
//                       dateController: dateController[index],
//                       selectedDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                     );
//                   },
//                   textValidatorEmpty: "please_enter_date".tr),
//               SizedBox(
//                 height: height * .02,
//               ),
// textFieldWidgetWithoutFilledWithFunctionSmall(
//                 context: context,
//                 fun: () {
//                   selectTime(
//                       context: context, timeController: timeController[index]);
//                 },
//                 icons: const Icon(Icons.access_time),
//                 controller: timeController[index],
//                 hintText: "time".tr,
//                 textValidatorEmpty: "please_enter_time".tr,
//               ),
//               SizedBox(
//                 height: height * .02,
//               ),
//               textFieldWidgetWithoutFilled(
//                   context: context,
//                   obscureText: false,
//                   type: TextInputType.text,
//                   hintText: "name".tr,
//                   controller: customerNameController[index],
//                   icons: const Icon(
//                     Icons.person,
//                   ),
//                   textValidatorEmpty: "please_enter_name".tr),
//               SizedBox(
//                 height: height * .02,
//               ),
//               TextFormField(
//                 maxLength: phoneNumberLength,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'please_enter_phone_number'.tr;
//                   } else if (value.length < 10) {
//                     return 'phone_number_not_valid'.tr;
//                   }
//                   return null;
//                 },
//                 keyboardType: TextInputType.phone,
//                 onChanged: (value) {
//                   if (customerNumberController[index].text.length <= 1) {
//                     setState(() {
//                       phoneNumberLength = 20;
//                     });
//                   }
//                   customerNumberController[index].text =
//                       value.removeAllWhitespace;
//                   setState(() {
//                     phoneNumberLength = 10;
//                   });
//                 },
//                 controller: customerNumberController[index],
//                 style: const TextStyle(fontSize: 18.0),
//                 cursorColor: Colors.black,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.phone_iphone),
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   hintText: 'phone_number'.tr,
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           const BorderSide(color: secondaryColor1, width: 1.0)),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: secondaryColor1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: secondaryColor1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: secondaryColor1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: height * .02,
//               ),
//               TextField(
//                 controller: notesController[index],
//                 textAlignVertical: TextAlignVertical.center,
//                 textInputAction: TextInputAction.done,
//                 style: const TextStyle(fontSize: 18.0),
//                 cursorColor: Colors.white,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(
//                     Icons.note_outlined,
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   hintText: 'notes'.tr,
//                   focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           const BorderSide(color: secondaryColor1, width: 1.0)),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: secondaryColor1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: secondaryColor1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: secondaryColor1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 minLines: 1,
//                 maxLines: null,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> addTripToList() async {
//     await onUpdate(trips.length, customerLocations[trips.length]);
//     Map<String, dynamic> json = {
//       'Destination': customerDestinations[trips.length],
//       'Date': dateController[trips.length].text,
//       'Time': timeController[trips.length].text,
//       'Location': customerLocations[trips.length],
//       'customerName': customerNameController[trips.length].text,
//       'phoneNumber': customerNumberController[trips.length].text,
//       'price':
//           double.parse(tripPrice ?? trips[trips.length - 1].price.toString()),
//       'currency': tripCurrency,
//     };
//     if (trips.contains(ListElement.fromJson(json))) {
//       return;
//     }
//     setState(() {
//       trips.insert(trips.length - 1, ListElement.fromJson(json));
//       activeStep = trips.length;
//       tripPrice = null;
//       log("*************");
//       logInfo("Active Step : $activeStep");
//       logInfo(
//           'Trips : ${trips.toList().toString()} ${trips.length.toString()}');
//     });
//   }

//   /// Returns the next button.
//   Widget _nextStep(StepEnabling enabling) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             offset: const Offset(0.0, 1.0), //(x,y)
//             blurRadius: 6.0,
//           ),
//         ],
//       ),
//       child: IconButton(
//         onPressed: () async {
//           // logInfo(activeStep.toString());
//           // logError(trips.length.toString());
//           if (projectName.text.isNotEmpty) {
//             if (activeStep <= trips.length) {
//               if (activeStep == 0) {
//                 setState(() => activeStep = activeStep + 1);
//               } else if (activeStep != 0) {
//                 logInfo(activeStep.toString());
//                 if (activeStep == trips.length) {
//                   if (formKeys[activeStep].currentState!.validate()) {
//                     await addTripToList();
//                     // sendInfo();
//                     return;
//                   }
//                 }
//                 if (formKeys[activeStep].currentState!.validate()) {
//                   if (activeStep != trips.length - 1) {
//                     await onUpdate(activeStep + 1, trips[activeStep].location!);
//                   } else {
//                     await onUpdate(
//                         trips.length, customerLocations[trips.length]);
//                   }
//                   setState(() => activeStep = activeStep + 1);
//                 }
//               }
//             }
//             if (activeStep2 < upperBound) {
//               setState(() {
//                 if (enabling == StepEnabling.sequential) {
//                   ++activeStep2;
//                   if (reachedStep < activeStep2) {
//                     reachedStep = activeStep2;
//                   }
//                 } else {
//                   activeStep2 = reachedSteps
//                       .firstWhere((element) => element > activeStep2);
//                 }
//               });
//             }
//           } else {
//             customSnackBar(
//                 context, "please_enter_project_name".tr, "Required".tr);
//           }
//         },
//         icon: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: activeStep == trips.length
//                   ? Text("Add Trip".tr)
//                   : Text("Next".tr),
//             ),
//             const Icon(Icons.arrow_forward_ios),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Returns the previous button.
//   Widget _previousStep(StepEnabling enabling) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             offset: const Offset(0.0, 1.0), //(x,y)
//             blurRadius: 6.0,
//           ),
//         ],
//       ),
//       child: IconButton(
//         onPressed: () async {
//           if (formKeys[activeStep].currentState!.validate()) {
//             if (activeStep <= trips.length) {
//               setState(() => activeStep = activeStep - 1);
//               await onUpdate(activeStep, trips[activeStep - 1].location!);
//             }
//           }
//           if (activeStep2 > 0) {
//             setState(() => enabling == StepEnabling.sequential
//                 ? --activeStep2
//                 : activeStep2 =
//                     reachedSteps.lastWhere((element) => element < activeStep2));
//           }
//         },
//         icon: const Row(
//           children: [
//             Icon(Icons.arrow_back_ios),
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text("Previous"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> onUpdate(int entryIndex, String trips) async {
//     setState(() {
//       isTripPriceLoading = true;
//     });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var sharedToken = prefs.getString('access_token_company');
//     String apiUrl = ApiApp.getTotalTransportationOrder;
//     var body = {
//       'destination': customerDestinations[entryIndex],
//       'trips': isMultiLocation == true ? "Multi Location Way" : trips,
//       'vehicleType': widget.type,
//       'numberOfTrips': '1',
//       'token': sharedToken,
//       'mobile': '1'
//     };
//     http.Response response = await http.post(Uri.parse(apiUrl), body: body);
//     var jsonResponse = jsonDecode(response.body);
//     logInfo('prices >>>>>>>>>>>>> $jsonResponse');
//     logWarning(body.toString());
//     setState(() {
//       tripPrice = jsonResponse['totalPrice'].toString();
//       tripCurrency = jsonResponse['currency'].toString();
//       isTripPriceLoading = false;
//     });
//   }

//   void sendInfo() async {
//     debugPrint("Forward Button click complete step call back!");
//     if (formKeys[activeStep].currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//         isComplete = true;
//       });
//       await addTripToList();
//       trips.removeAt(trips.length - 1);
//       for (int i = 0; i < trips.length; i++) {
//         logInfo(trips[i].toJson().toString());
//         totalTripsPrice = totalTripsPrice + trips[i].price!;
//       }
//       Trips trip = Trips(
//           list: trips,
//           phone: customerNumberController[0].text,
//           startTime: timeController[0].text,
//           startDate: dateController[0].text,
//           name: customerNameController[0].text,
//           vechileType: widget.type,
//           token: '',
//           mobile: 1,
//           totalPrice: double.parse(totalTripsPrice.toString()),
//           projectName: projectName.text);
//       logInfo(trip.toJson().toString());
//       pushReplacement(
//           context,
//           DetailsMultiTripCompany(
//             mapMobile: trip,
//             totalPrice: totalTripsPrice,
//             vechileType: widget.type,
//             projectName: projectName.text,
//             name: '',
//             phone: '',
//           ));
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }

// enum StepEnabling { sequential, individual }