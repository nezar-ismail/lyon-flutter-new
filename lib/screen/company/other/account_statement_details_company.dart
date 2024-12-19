import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyon/model/account_statement_model.dart';
import 'package:lyon/screen/company/other/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../api/api.dart';

// ignore: must_be_immutable
class AccountStatementDetailsCompany extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final dateFrom;
  String? projectName;
  String? accountType;
  // ignore: prefer_typing_uninitialized_variables
  final dateTo;
  AccountStatementDetailsCompany(
      {super.key,
      this.dateFrom,
      this.dateTo,
      this.accountType,
      this.projectName});

  @override
  State<AccountStatementDetailsCompany> createState() =>
      _AccountStatementDetailsCompanyState();
}

class _AccountStatementDetailsCompanyState
    extends State<AccountStatementDetailsCompany> {
  late Future<AccountStatementModel> futurePost;
  TextEditingController email = TextEditingController();
  String? apiUrl;
  String? sharedToken;
  Future<AccountStatementModel> accountStatementComoany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // if (widget.accountType == 'customer') {
    //   apiUrl = ApiApp.accountStatement;
    //   sharedToken = _prefs.getString('access_token');
    // } else if(widget.accountType == 'company') {
    apiUrl = ApiApp.getCompanyAccountStatement;
    sharedToken = prefs.getString('access_token_company');
    // }

    final json = {
      "dateFrom": widget.dateFrom,
      "dateTo": widget.dateTo,
      "token": sharedToken,
      "projectName": widget.projectName,
      "mobile": "1"
    };
    http.Response response = await http.post(Uri.parse(apiUrl!), body: json);

    var jsonResponse = jsonDecode(response.body);
    return AccountStatementModel.fromJson(jsonResponse);
  }

  @override
  void initState() {
    //futurePost = accountStatementComoany();
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
      projectName: widget.projectName,
    );
  }
}