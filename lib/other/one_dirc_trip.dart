// import 'dart:convert';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:intl/intl.dart';
// import 'package:lyon/api/api.dart';
// import 'package:lyon/screen/payment_page_transpotation.dart';
// import 'package:lyon/shared/Widgets/text_field_widget.dart';
// import 'package:lyon/shared/Widgets/custom_text.dart';
// import 'package:lyon/shared/mehod/switch_sreen.dart';
// import 'package:lyon/shared/styles/colors.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'choose_one_image.dart';

// class OneDirctiontrip extends StatefulWidget {
//   final String image;
//   final String price;
//   final String type;

//   const OneDirctiontrip(
//       {Key? key, required this.image, required this.price, required this.type})
//       : super(key: key);
//   @override
//   _OneDirctiontripState createState() => _OneDirctiontripState();
// }

// class _OneDirctiontripState extends State<OneDirctiontrip> {
//   TextEditingController dateController = TextEditingController();
//   TextEditingController timeController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool isLaoding = true;
//   String? price;
//   String? id;
//   String? currency;
//   bool isVisiblePrice = false;
//   bool isVisibleTicket = false;
//   bool isCheckTicket = false;
//     bool isCheckPassport = false;
//   bool isUploadTicketSuccess = false;
//   bool isVisiblePassport = true;
//   bool isUploadPassportSuccess = false;
//   bool isLoadingCreateOrder = false;
// String locationTicket = '';
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
//             "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
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
//       // time = pickedTime.format(context);
//       DateTime parsedTime =
//           DateFormat.Hm().parse(pickedTime.format(context).toString());
//       // ignore: unused_local_variable
//       String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
//       setState(() {
//         timeController.text = pickedTime.format(context);
//         // firstHour = pickedTime.hour;
//         // firstMinute = pickedTime.minute;
//       });
//     }
//   }

//   List<String> locations = [];

//   var prices = {};
//   getTransportationRoutes() async {
//     String apiUrl = ApiApp.getTransportationRoutes;
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     var token = _prefs.getString('access_token');
//     http.Response response = await http.post(Uri.parse(apiUrl),
//         body: {"token": token, "type": widget.type, "mobile": "1"});

//     var jsonResponse = jsonDecode(response.body);

//     for (var i = 0; i < jsonResponse.length; i++) {
//       prices[jsonResponse[i]["locations"]] = {};
//       prices[jsonResponse[i]["locations"]]["carPrice"] =
//           jsonResponse[i]["carPrice"];
//       prices[jsonResponse[i]["locations"]]["vanPrice"] =
//           jsonResponse[i]["vanPrice"];
//       prices[jsonResponse[i]["locations"]]["coasterPrice"] =
//           jsonResponse[i]["coasterPrice"];
//       prices[jsonResponse[i]["locations"]]["busPrice"] =
//           jsonResponse[i]["busPrice"];
//       prices[jsonResponse[i]["locations"]]["requireTicket"] =
//           jsonResponse[i]["requireTicket"];
//       prices[jsonResponse[i]["locations"]]["id"] = jsonResponse[i]["id"];
//       prices[jsonResponse[i]["locations"]]["currency"] =
//           jsonResponse[i]["currency"];
//       locations.add(jsonResponse[i]['locations']);
//     }
//   }

//   checkUserDocuments() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     var _sharedToken = _prefs.getString('access_token');
//     String apiUrl = ApiApp.checkUserDocuments;
//     final json = {"token": _sharedToken, "mobile": "1"};

//     http.Response response = await http.post(Uri.parse(apiUrl), body: json);

//     var jsonResponse = jsonDecode(response.body);
//     return jsonResponse;
//   }

//   @override
//   void initState() {
//     getTransportationRoutes().then((value) {
//       if (mounted) {
//         setState(() {
//           isLaoding = false;
//         });
//       }
//     });
//     checkUserDocuments().then((value){
//     if ( value == 2 ||  value == 3) {
//     setState(() {
//         isVisiblePassport = false;
//     });
//     } else {
//      setState(() {
//         isVisiblePassport = true;
//      });
//     }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _width = MediaQuery.of(context).size.width;
//     final _height = MediaQuery.of(context).size.height;
//     return Form(
//       key: _formKey,
//       child: Scaffold(
//           backgroundColor: Colors.grey.shade300,
//           appBar: AppBar(
//             backgroundColor: secondaryColor1,
//             title: Text('select_destination'.tr),
//             centerTitle: true,
//           ),
//           body: isLaoding
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : Center(
//                   child: SizedBox(
//                     width: _width * .90,
//                     height: _height * .80,
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: SingleChildScrollView(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Center(
//                                   child: Image.asset(widget.image,
//                                       width: _width / 2)),
//                               SizedBox(
//                                 height: _height * .03,
//                               ),
//                               SizedBox(
//                                 width: _width * .75,
//                                 child: DropdownSearch<String>(
//                                   dropdownSearchDecoration:
//                                       const InputDecoration(
//                                           errorBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: secondaryColor1),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10))),
//                                           border: InputBorder.none,
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: secondaryColor1),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(10))),
//                                           contentPadding: EdgeInsets.only(
//                                               right: 20, left: 20)),
//                                   popupBarrierColor:
//                                       Colors.black.withOpacity(.5),
//                                   validator: (value) => value == null
//                                       ? 'please_enter_destination'.tr
//                                       : null,
//                                   mode: Mode.DIALOG,
//                                   items: locations,
//                                   showSearchBox: true,
//                                   // ignore: deprecated_member_use
//                                   label: "select_destination".tr,
//                                   // label: "First Location",
//                                   onChanged: (value) {
//                                     setState(() {
//                                       price = prices[value][widget.price];
//                                       isVisiblePrice = true;
//                                       currency = prices[value]['currency'];
//                                       id = prices[value]['id'];
//                                       if (prices[value]['requireTicket'] ==
//                                           '1') {
//                                         isVisibleTicket = true;
//                                       } else {
//                                         isVisibleTicket = false;
//                                         isCheckTicket = false;
//                                         isUploadTicketSuccess = false;
//                                       }
//                                     });
//                                   },
//                                   filterFn: (instance, filter) {
//                                     if (instance!.contains(filter!)) {
//                                       return true;
//                                     } else if (instance
//                                         .toLowerCase()
//                                         .contains(filter.toLowerCase())) {
//                                       return true;
//                                     } else {
//                                       return false;
//                                     }
//                                   },
//                                 ),
//                               ),
                         
//                              SizedBox(
//                                 height: _height * .02,
//                               ),
//                               SizedBox(
//                                 width: _width * .75,
//                                 // height: _height * .1,
//                                 child: textFieldWidgetWithoutFilledWithFunction(
//                                     context: context,
//                                     hintText: "pickup_date".tr,
//                                     controller: dateController,
//                                     icons: const Icon(
//                                       Icons.calendar_today,
//                                     ),
//                                     fun: () => selectDate(
//                                           context: context,
//                                           dateController: dateController,
//                                           selectedDate: DateTime.now(),
//                                           firstDate: DateTime.now(),
//                                         ),
//                                     textValidatorEmpty: "please_enter_date".tr),
//                               ),
//                               SizedBox(
//                                 height: _height * .02,
//                               ),
//                               SizedBox(
//                                 width: _width * .75,
//                                 // height: _height * .1,
//                                 child:
//                                     textFieldWidgetWithoutFilledWithFunctionSmall(
//                                   context: context,
//                                   fun: () {
//                                     selectTime(
//                                         context: context,
//                                         timeController: timeController);
//                                   },
//                                   icons: const Icon(Icons.access_time),
//                                   controller: timeController,
//                                   hintText: "start_time".tr,
//                                   textValidatorEmpty: "please_enter_time".tr,
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: isVisiblePrice,
//                                 child: SizedBox(
//                                   height: _height * .02,
//                                 ),
//                               ),
//                               Visibility(
//                                   visible: isVisiblePrice,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       CustomText(
//                                         text: 'total'.tr,
//                                         fontWeight: FontWeight.bold,
//                                         size: 20,
//                                       ),
//                                       SizedBox(
//                                         width: _width * .02,
//                                       ),
//                                       CustomText(
//                                         text: price.toString() +
//                                             ' ${currency.toString()}',
//                                         size: 20,
//                                       ),
//                                     ],
//                                   )),
//                                   SizedBox(
//                                   height: _height * .01,
//                                 ),
//                                   Visibility(
//                                     visible:isVisiblePassport ,
//                                     // ignore: deprecated_member_use
//                                     child: ElevatedButton(
//                                                      style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.shade300,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),),
//                                     onPressed: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   UploadPassportPhoto(
//                                                     title:
//                                                         'upload_passport_id_photos'.tr,
//                                                   ))).whenComplete(() {
//                                         setState(() {
//                                           isVisiblePassport = false;
//                                           isUploadPassportSuccess = true;
//                                           isCheckPassport = false;
//                                         });
//                                       });
//                                     },
//                                     child: Text(
//                                       'upload_passport_id_photos'.tr,
//                                       style: const TextStyle(color: Colors.white),
//                                     ),
//                                                                   ),
//                                   ),
//                                    Visibility(
//                                 visible: isUploadPassportSuccess,
//                                 child: Text(
//                                   'passport_uploaded_successfully'.tr,
//                                   style: const TextStyle(color: Colors.green),
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: isCheckPassport,
//                                 child: Text(
//                                   'please_upload_passport'.tr,
//                                   style: const TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                               // Visibility(
//                               //   visible: isVisiblePrice,
//                               //   child: SizedBox(
//                               //     height: _height * .01,
//                               //   ),
//                               // ),
//                               Visibility(
//                                 visible: isVisibleTicket,
//                                 // ignore: deprecated_member_use
//                                 child: ElevatedButton(
//                                                         style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.shade300,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),),
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 UploadPassportPhoto(
//                                                   title:
//                                                       'upload_ticket_photo'.tr,
//                                                 ))).whenComplete(() {
//                                       setState(() {
//                                         locationTicket="Outside of Jordan";
//                                         isVisibleTicket = false;
//                                         isCheckTicket = false;
//                                         isUploadTicketSuccess = true;
//                                       });
//                                     });
//                                   },
//                                   child: Text(
//                                     'upload_ticket_photo'.tr,
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: isUploadTicketSuccess,
//                                 child: Text(
//                                   'ticket_uploaded_successfully'.tr,
//                                   style: const TextStyle(color: Colors.green),
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: isCheckTicket,
//                                 child: Text(
//                                   'please_upload_ticket'.tr,
//                                   style: const TextStyle(color: Colors.red),
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: isVisibleTicket,
//                                 child: SizedBox(
//                                   height: _height * .01,
//                                 ),
//                               ),
//                               // SizedBox(
//                               //   height: _height * .02,
//                               // ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * .50,
//                                 // ignore: deprecated_member_use
//                                 child: ElevatedButton(
//                                                           style: ElevatedButton.styleFrom(
//                         backgroundColor: secondaryColor1,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),),
//                                     onPressed: () {
//                                       if (_formKey.currentState!.validate() &&
//                                           isVisibleTicket == false&&isVisiblePassport == false) {
//                                         showDialog(
//                                           barrierDismissible: false,
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             bool isChecked = false;
//                                             return StatefulBuilder(builder:
//                                                 (BuildContext context,
//                                                     StateSetter setState) {
//                                               return isLoadingCreateOrder
//                                                   ? const Center(
//                                                       child:
//                                                           CircularProgressIndicator(),
//                                                     )
//                                                   : AlertDialog(
//                                                       backgroundColor:
//                                                           Colors.grey.shade300,
//                                                       title: Text(
//                                                           "terms_and_conditions"
//                                                               .tr),
//                                                       content: SizedBox(
//                                                         height: MediaQuery.of(
//                                                                 context)
//                                                             .size
//                                                             .height,
//                                                         width: MediaQuery.of(
//                                                                 context)
//                                                             .size
//                                                             .width,
//                                                         child: ListView(
//                                                           shrinkWrap: true,
//                                                           children: [
//                                                             Text('\u2022 ' +
//                                                                 'term1_trip'.tr +
//                                                                 '\n'),            
//                                                             Text('\u2022 ' +
//                                                                 'term4_trip'.tr +
//                                                                 '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term5_trip'.tr +
//                                                                 '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term6_trip'.tr + '\n'+
//                                                                 '\n    -	' +
//                                                                 'term6_trip_1'.tr+
//                                                                  '\n    -	' +'term6_trip_2'.tr+ '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term7_trip'.tr +
//                                                                 '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term8_trip'.tr +
//                                                                 '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term9_trip'.tr +
//                                                                 '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term10_trip'.tr +
//                                                                 '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term11_trip'.tr +
//                                                                 '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term12_trip'.tr +
//                                                                 '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term13_trip'.tr +'\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term14_trip'.tr +
//                                                                 '\n'),
//                                                             Text('\u2022 ' +
//                                                                 'term15_trip'.tr + '\n'+
//                                                                 '\n    -	' +
//                                                                 'term15_trip_1'.tr +
//                                                                 '\n    -	' +
//                                                                 'term15_trip_2'.tr +
//                                                                 '\n'),
//                                                             CheckboxListTile(
//                                                               contentPadding:
//                                                                   EdgeInsets
//                                                                       .zero,
//                                                               title: Text(
//                                                                   'i_read_and_agree'
//                                                                       .tr),
//                                                               value: isChecked,
//                                                               onChanged:
//                                                                   (value) {
//                                                                 setState(() {
//                                                                   isChecked =
//                                                                       value!;
//                                                                 });
//                                                               },
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       actions: <Widget>[
//                                                         isChecked == false
//                                                             // ignore: deprecated_member_use
//                                                             ? TextButton(
//                                                                 onPressed: null,
//                                                                 child: Text(
//                                                                     'ok'.tr),
//                                                               )
//                                                             // ignore: deprecated_member_use
//                                                             : TextButton(
//                                                                 child: Text(
//                                                                     "ok".tr),
//                                                                 onPressed:
//                                                                     () async {
//                                                                   push(
//                                                                       context,
//                                                                       CashOrVisaTranspotation(
//                                                                         locationTicket:locationTicket.toString(),
//                                                                           startDate: dateController
//                                                                               .text,
//                                                                           startTime: timeController
//                                                                               .text,
//                                                                           totalPrice: price
//                                                                               .toString(),
//                                                                           vehicleType: widget
//                                                                               .type,
//                                                                           destination:
//                                                                               id,
//                                                                           currency:
//                                                                               currency));
//                                                                 },
//                                                               ),
//                                                         // ignore: deprecated_member_use
//                                                         TextButton(
//                                                           child:
//                                                               Text("cancel".tr),
//                                                           onPressed: () {
//                                                             Navigator.of(
//                                                                     context)
//                                                                 .pop();
//                                                           },
//                                                         ),
//                                                       ],
//                                                     );
//                                             });
//                                           },
//                                         );
//                                       } else if (isVisibleTicket == true) {
//                                         setState(() {
//                                           isCheckTicket = true;
                                         
//                                         });
//                                       }else if (isVisiblePassport == true) {
//                                         setState(() {
//                                           isCheckPassport = true;
                                         
//                                         });
//                                       }
//                                     },
//                                     child:  Text(
//                                       'confirm'.tr,
//                                       style: const TextStyle(color: Colors.white),
//                                     )),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//           //   }
//           // ),
//           ),
//     );
//   }
// }
