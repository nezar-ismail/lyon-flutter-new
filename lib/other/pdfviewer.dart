// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:lyon/api/serviceprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';

// ignore: must_be_immutable
class PdfViewerPage extends StatefulWidget {
  String? dateFrom;
  String? dateTo;

  PdfViewerPage({
    super.key,
    required this.dateFrom,
    required this.dateTo,
  });
  @override
  // ignore: library_private_types_in_public_api
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? apiUrl;
  String? sharedToken;

  @override
  void initState() {
    super.initState();
    ApiServiceProvider.loadAccountStatement(
            widget.dateFrom ?? "1/1/2024", widget.dateTo ?? "1/1/2030")
        .then((value) {
      setState(() {
        localPath = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "account_statement".tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: localPath == '404'
          ? Center(
              child: Text(
                "you_do_not_have_any_account_statement".tr,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : localPath != null
              ? Stack(children: [
                  PDFView(
                    filePath: localPath,
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    left: MediaQuery.of(context).size.width * 0.5 -
                        (MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? MediaQuery.of(context).size.width * 0.15
                            : MediaQuery.of(context).size.width * 0.35),
                    child: SizedBox(
                      width: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? MediaQuery.of(context).size.width * 0.3
                          : MediaQuery.of(context).size.width * 0.7,
                      child: SizedBox(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? MediaQuery.of(context).size.height * 0.15
                            : MediaQuery.of(context).size.height * 0.06,
                        child: localPath == '404'
                            ? const SizedBox()
                            : button(
                                context: context,
                                text: "send_it_by_email".tr,
                                function: () {
                                  Get.bottomSheet(BottomSheet(
                                    onClosing: () {},
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: const EdgeInsets.all(25),
                                        child: SingleChildScrollView(
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                textFieldWidgetWithoutFilled(
                                                    context: context,
                                                    controller: email,
                                                    checkEmail: true,
                                                    textValidatorEmail:
                                                        "please_enter_correct_email"
                                                            .tr,
                                                    hintText: "email".tr,
                                                    textValidatorEmpty:
                                                        "please_enter_email".tr,
                                                    type: TextInputType
                                                        .emailAddress,
                                                    obscureText: false,
                                                    icons: const Icon(
                                                        Icons.email)),
                                                const SizedBox(height: 25),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                              .orientation ==
                                                          Orientation.landscape
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.15
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.06,
                                                  child: button(
                                                      context: context,
                                                      text: 'confirm'.tr,
                                                      function: () async {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            SharedPreferences
                                                                prefs =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            prefs.getString(
                                                                    'access_token');
                                                            Navigator.pop(
                                                                // ignore: use_build_context_synchronously
                                                                context);
                                                          }
                                                        }
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ); // Replace 'Container()' with your desired widget
                                    },
                                  ));
                                },
                              ),
                      ),
                    ),
                  ),
                ])
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
