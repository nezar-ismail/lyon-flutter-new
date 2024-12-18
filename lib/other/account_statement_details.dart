import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyon/other/main_screen.dart';
import 'package:lyon/other/pdfviewer.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';

// ignore: must_be_immutable
class AccountStatementDetails extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final dateFrom;

  String? accountType;
  // ignore: prefer_typing_uninitialized_variables
  final dateTo;
  AccountStatementDetails(
      {super.key, this.dateFrom, this.dateTo, this.accountType});

  @override
  State<AccountStatementDetails> createState() =>
      _AccountStatementDetailsState();
}

class _AccountStatementDetailsState extends State<AccountStatementDetails> {
  late Future<String> futurePost;
  TextEditingController email = TextEditingController();
  String? apiUrl;
  String? sharedToken;
  Future<String> accountStatementCustomer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // if (widget.accountType == 'customer') {
    apiUrl = ApiApp.accountStatement;
    sharedToken = prefs.getString('access_token');
    var userEmail = prefs.getString('email');
    // } else if(widget.accountType == 'company') {
    // apiUrl = ApiApp.getCompanyAccountStatement;
    // sharedToken = _prefs.getString('access_token_company');
    // }

    final json = {
      "dateFrom": widget.dateFrom,
      "dateTo": widget.dateTo,
      "token": sharedToken,
      "mobile": "1",
      "email": userEmail
    };

    http.Response response = await http.post(Uri.parse(apiUrl!), body: json);
    // print("response $response");
    if (response.statusCode == 404) {
      // ignore: use_build_context_synchronously
      push(context, MainScreen(numberIndex: 1));
    }
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;

    //print("body " + response.body);
    //var jsonResponse = jsonDecode(response.body);
    //print("response $jsonResponse");
    //return AccountStatementModel.fromJson(jsonResponse);
    //print("test" + AccountStatementModel.fromJson(jsonResponse).toString());
    //return AccountStatementModel.fromJson(jsonResponse);
    //return AccountStatementModel.fromJson(jsonDecode(response.body));
  }

  @override
  void initState() {
    //futurePost = accountStatementCustomer();
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      //       DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PdfViewerPage(
      dateFrom: widget.dateFrom,
      dateTo: widget.dateTo,
    );
    //final _width = MediaQuery.of(context).size.width;
    //final _height = MediaQuery.of(context).size.height;
    // return Form(
    //   key: _formKey,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       centerTitle: true,
    //       title: Text('account_statement_details'.tr),
    //       backgroundColor: secondaryColor1,
    //     ),
    //     body:
    //     // FutureBuilder<AccountStatementModel>(
    //     //   future: futurePost,
    //     //   builder: (context, snapshot) {
    //     //     if (snapshot.connectionState == ConnectionState.waiting) {
    //     //       return const Center(child: CircularProgressIndicator());
    //     //     } else if (snapshot.data!.status == 200) {
    //     //       //   snapshot.error == true||
    //     //       //  snapshot.data?.status == 0||
    //     //       //             snapshot.data == null ||
    //     //       //             snapshot.connectionState == ConnectionState.none) {
    //     //       //           return const CircularProgressIndicator();
    //     //       //         }

    //     //       return ListView(
    //     //         children: [
    //     //           DataTable(
    //     //             columns: const [
    //     //               DataColumn(label: Text('Date')),
    //     //               DataColumn(label: Text('No.')),
    //     //               DataColumn(label: Text('Sevice')),
    //     //               DataColumn(label: Text('Debits')),
    //     //               DataColumn(label: Text('Credits')),
    //     //               DataColumn(label: Text('Balance')),
    //     //               DataColumn(label: Text('Details')),
    //     //             ],
    //     //             rows: List.generate(
    //     //               snapshot.data!.paymentsArray!.length,
    //     //               (index) {
    //     //                 // var emp = a[index];
    //     //                 return DataRow(cells: [
    //     //                   DataCell(
    //     //                     Text(snapshot.data!.paymentsArray![index].date
    //     //                         .toString()),
    //     //                   ),
    //     //                   DataCell(
    //     //                     Text(snapshot.data!.paymentsArray![index].number
    //     //                         .toString()),
    //     //                   ),
    //     //                   DataCell(
    //     //                     Text(snapshot.data!.paymentsArray![index].service
    //     //                         .toString()),
    //     //                   ),
    //     //                   DataCell(
    //     //                     Text(snapshot.data!.paymentsArray![index].debit
    //     //                             .toString() +
    //     //                         ' JD'),
    //     //                   ),
    //     //                   DataCell(
    //     //                     Text(snapshot.data!.paymentsArray![index].credit
    //     //                             .toString() +
    //     //                         ' JD'),
    //     //                   ),
    //     //                   DataCell(
    //     //                     Text(snapshot.data!.paymentsArray![index].balance
    //     //                             .toString() +
    //     //                         ' JD'),
    //     //                   ),
    //     //                   DataCell(
    //     //                     Text(
    //     //                       snapshot.data!.paymentsArray![index].details
    //     //                           .toString(),
    //     //                       style: const TextStyle(fontSize: 10),
    //     //                     ),
    //     //                   ),
    //     //                 ]);
    //     //               },
    //     //             ).toList(),
    //     //           ),
    //     //           SizedBox(
    //     //             height: _height * .02,
    //     //           ),
    //     //           Container(
    //     //             color: secondaryColor1,
    //     //             height: _height * .01,
    //     //           ),
    //     //           SizedBox(
    //     //             height: _height * .04,
    //     //           ),
    //     //           Column(
    //     //             mainAxisAlignment: MainAxisAlignment.start,
    //     //             crossAxisAlignment: CrossAxisAlignment.center,
    //     //             children: [
    //     //               Row(
    //     //                 crossAxisAlignment: CrossAxisAlignment.center,
    //     //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     //                 children: [
    //     //                   Text(
    //     //                       'Debit : ' + snapshot.data!.totalDebit.toString(),
    //     //                       style: const TextStyle(
    //     //                           fontSize: 16, fontWeight: FontWeight.bold)),
    //     //                   Text(
    //     //                       'Credit : ' +
    //     //                           snapshot.data!.totalCredit.toString(),
    //     //                       style: const TextStyle(
    //     //                           fontSize: 16, fontWeight: FontWeight.bold)),
    //     //                 ],
    //     //               ),
    //     //               Text(
    //     //                   'Balance : ' + snapshot.data!.totalBalance.toString(),
    //     //                   style: const TextStyle(
    //     //                       fontSize: 20, fontWeight: FontWeight.bold)),
    //     //             ],
    //     //           ),
    //               SizedBox(
    //                 height: _height * .04,
    //               ),
    //               Center(
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   children: [
    //                     SizedBox(
    //                       width: _width * .5,
    //                       child: textFieldWidgetWithoutFilled(
    //                           context: context,
    //                           controller: email,
    //                           checkEmail: true,
    //                           textValidatorEmail:
    //                               "please_enter_correct_email".tr,
    //                           hintText: "email".tr,
    //                           textValidatorEmpty: "please_enter_email".tr,
    //                           type: TextInputType.text,
    //                           obscureText: false,
    //                           icons: const Icon(Icons.email)),
    //                     ),
    //                     SizedBox(
    //                         width: _width * .25,
    //                         height: _height * .1,
    //                         // ignore: deprecated_member_use
    //                         child: ElevatedButton(
    //                           style: ElevatedButton.styleFrom(
    //                             backgroundColor: secondaryColor1,
    //                             shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(10),
    //                             ),
    //                           ),
    //                           child: Text(
    //                             'confirm'.tr,
    //                             style: const TextStyle(color: Colors.white),
    //                           ),
    //                           onPressed: () async {
    //                             if (_formKey.currentState!.validate()) {
    //                               String apiUrl =
    //                                   ApiApp.sendAccountStatementByEmail;
    //                               SharedPreferences _prefs =
    //                                   await SharedPreferences.getInstance();
    //                               var _sharedToken =
    //                                   _prefs.getString('access_token');
    //                               final json = {
    //                                 "dateFrom": widget.dateFrom,
    //                                 "dateTo": widget.dateTo,
    //                                 "token": _sharedToken,
    //                                 'email': email.text.toString()
    //                               };
    //                               Navigator.pop(context);
    //                               // ignore: unused_local_variable
    //                               http.Response response = await http
    //                                   .post(Uri.parse(apiUrl), body: json)
    //                                   .whenComplete(
    //                                 () {
    //                                   showMessage(
    //                                       context: context,
    //                                       text:
    //                                           "email_has_been_sent_successfully"
    //                                               .tr);
    //                                 },
    //                               );
    //                             }
    //                           },
    //                         )),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: _height * .1,
    //               ),
    //               //                    Center(

    //               //                    )
    //             ],
    //           );
    //         } else {
    //           return Align(
    //               alignment: Alignment.center,
    //               child: Text('you_do_not_have_an_account_statement'.tr,
    //                   style: const TextStyle(
    //                       fontSize: 20, fontWeight: FontWeight.bold)));
    //         }
    //       },
    //     ),
    //   ),
    //);
  }
}
