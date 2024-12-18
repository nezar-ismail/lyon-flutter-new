// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/screen/auth/view_image.dart';
import 'package:lyon/shared/Widgets/text_field_widget.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/utils/Translate/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as prefix;
import '../../shared/Widgets/custom_text.dart';
import 'package:http/http.dart' as http;
File? _image;
File? _image2;
class EditInformation extends StatefulWidget {
  const EditInformation({super.key});
  @override
  _EditInformationState createState() => _EditInformationState();
}
class _EditInformationState extends State<EditInformation> {
  TextEditingController address = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController email = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String cc = '';
  String phone = '';
  String emailStr = '';
  String iD_Passport = '';
  String license = '';
  bool isVisablePhoneNumber = false;
  bool showCircleLoading = false;
  bool getDocumentLoading = true;
  var dio = prefix.Dio();
  updateInformation() async {
    String apiUrl = ApiApp.editProfile;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token');
    var formData = prefix.FormData.fromMap({
      'token': _sharedToken.toString(),
      'mobileNumber': phoneController.text.toString().removeAllWhitespace,
      "countryCode":
          theRealPhone != null ? theRealPhone!.dialCode.toString() : '',
      'address': address.text.toString(),
      'street': street.text.toString(),
      "mobile": "1"
    });
    await dio.post(apiUrl, data: formData).whenComplete(() async {
      setState(() {
        showCircleLoading = false;
      });
      var sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('street', street.text);
      sharedPreferences.setString('address', address.text);
      showMessage(context: context, text: 'User data updated successfully.');
      Get.back();
    });
  }
  getUserDocument() async {
    String apiUrl = ApiApp.getUserDocument;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token');
    final json = {"token": _sharedToken, "mobile": "1"};

    http.Response response = await http.post(Uri.parse(apiUrl), body: json);

    var jsonResponse = jsonDecode(response.body);
    setState(() {
      cc = jsonResponse['countryCode'];
      phone = jsonResponse['phoneNumber'];
      emailStr = jsonResponse['email'];
      iD_Passport = jsonResponse['iD_Passport'];
      license = jsonResponse['License'];
      address.text = _prefs.getString("address") ?? "";
      street.text = _prefs.getString("street") ?? "";
    });
  }
  @override
  void initState() {
    super.initState();
    getUserDocument().then((value) {
      if (mounted) {
        setState(() {
          getDocumentLoading = false;
        });
      }
    });
  }
  @override
  void dispose() {
    _image = null;
    _image2 = null;
    super.dispose();
  }
  PhoneNumber? theRealPhone;
  final _formKey = GlobalKey<FormState>();
  bool isSavedButton = false;
  bool checkLengthNumber = false;
  bool isLengthNumber = false;
  bool check = true;
  final ImagePicker _imagePicker = ImagePicker();
  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'choose_image'.tr,
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
            if (image != null)
              // ignore: curly_braces_in_flow_control_structures
              setState(() {
                isSavedButton = true;
                _image = File(image.path);
              });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('choose_image'.tr),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image =
                await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null)
              // ignore: curly_braces_in_flow_control_structures
              setState(() {
                isSavedButton = true;
                _image = File(image.path);
              });
          },
        ),
        _image != null
            ? CupertinoActionSheetAction(
                child: Text('view_image'.tr),
                isDestructiveAction: false,
                onPressed: () async {
                  push(
                      context,
                      ViewImage(
                        image: _image,
                      ));
                },
              )
            : Container()
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
  _onCameraClick2() {
    final action = CupertinoActionSheet(
      message: Text(
        'choose_image'.tr,
        style: const TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('choose_image_gallery'.tr),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image2 =
                await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image2 != null)
              setState(() {
                isSavedButton = true;
                _image2 = File(image2.path);
              });
          },
        ),
        CupertinoActionSheetAction(
          child: Text('choose_image'.tr),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image2 =
                await _imagePicker.pickImage(source: ImageSource.camera);
            if (image2 != null)
              setState(() {
                isSavedButton = true;
                _image2 = File(image2.path);
              });
          },
        ),
        _image2 != null
            ? CupertinoActionSheetAction(
                child: Text('view_image'.tr),
                isDestructiveAction: false,
                onPressed: () async {
                  push(
                      context,
                      ViewImage(
                        image: _image2,
                      ));
                },
              )
            : Container()
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
  bool openCircle = false;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: secondaryColor1,
          title: Text(
            "edit_profile".tr,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: getDocumentLoading == true
            ? const Center(child: CircularProgressIndicator())
            : showCircleLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: _width * .02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: _height * .04,
                            ),
                            CustomText(
                                text: 'phone_number_(optional)'.tr,
                                color: Colors.grey,
                                alignment:
                                    LocalizationService().getCurrentLang() ==
                                            "English"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight),
                            SizedBox(
                              height: _height * .01,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isVisablePhoneNumber = true;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                height: _height * .065,
                                decoration: BoxDecoration(
                                    border: Border.all(color: secondaryColor1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: isVisablePhoneNumber == true
                                    ? Visibility(
                                        visible: isVisablePhoneNumber,
                                        child: InternationalPhoneNumberInput(
                                          onInputChanged: (value) {
                                            if (value.phoneNumber!.length <
                                                    12 ||
                                                value.phoneNumber!.isEmpty) {
                                              setState(() {
                                                isSavedButton = false;
                                              });
                                            } else {
                                              setState(() {
                                                isSavedButton = true;
                                              });
                                            }
                                            theRealPhone = value;
                                          },
                                          selectorTextStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textFieldController: phoneController,
                                          inputBorder: InputBorder.none,
                                          inputDecoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 10),
                                              hintText:
                                                  "enter_your_phone_number".tr,
                                              border: InputBorder.none,
                                              hintStyle: const TextStyle(
                                                  color: Colors.black)),
                                          selectorConfig: const SelectorConfig(
                                            selectorType:
                                                PhoneInputSelectorType.DIALOG,
                                            useEmoji: true,
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isVisablePhoneNumber = true;
                                              });
                                            },
                                            child: CustomText(
                                              text: cc + '-' + phone,
                                              alignment: Alignment.center,
                                              size: 20,
                                            ))),
                              ),
                            ),
                            SizedBox(
                              height: _height * .01,
                            ),
                            CustomText(
                                text: 'email_(optional)'.tr,
                                color: Colors.grey,
                                alignment:
                                    LocalizationService().getCurrentLang() ==
                                            "English"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight),
                            SizedBox(
                              height: _height * .01,
                            ),
                            Form(
                              key: _formKey,
                              child:
                                  textFieldWidgetWithoutFilledWithEditFunction(
                                      context: context,
                                      readOnly: true,
                                      controller: email,
                                      checkEmail: true,
                                      textValidatorEmail:
                                          "please_enter_correct_email".tr,
                                      hintText: emailStr,
                                      type: TextInputType.text,
                                      obscureText: false,
                                      icons: const Icon(Icons.email),
                                      editFunction: () {
                                        setState(() {
                                          isSavedButton = true;
                                        });
                                      }),
                            ),
                            Visibility(
                              visible: check,
                              child: SizedBox(
                                height: _height * .02,
                              ),
                            ),
                            SizedBox(
                              height: _height * .01,
                            ),
                            CustomText(
                                text: 'address_(optional)'.tr,
                                color: Colors.grey,
                                alignment:
                                    LocalizationService().getCurrentLang() ==
                                            "English"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight),
                            SizedBox(
                              height: _height * .01,
                            ),
                            textFieldWidgetWithoutFilledWithEditFunction(
                                context: context,
                                icons: const Icon(Icons.location_city),
                                obscureText: false,
                                type: TextInputType.text,
                                hintText: "address".tr,
                                controller: address,
                                editFunction: () {
                                  setState(() {
                                    isSavedButton = true;
                                  });
                                }),
                            SizedBox(
                              height: _height * .01,
                            ),
                            CustomText(
                              text: 'street_(optional)'.tr,
                              alignment:
                                  LocalizationService().getCurrentLang() ==
                                          "English"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: _height * .01,
                            ),
                            textFieldWidgetWithoutFilledWithEditFunction(
                                context: context,
                                icons: const Icon(Icons.edit_road),
                                obscureText: false,
                                type: TextInputType.text,
                                hintText: "street".tr,
                                controller: street,
                                editFunction: () {
                                  setState(() {
                                    isSavedButton = true;
                                  });
                                }),
                            SizedBox(
                              height: _height * .02,
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: _image == null
                                        ? iD_Passport == ''
                                            ? Container(
                                                )
                                            : SizedBox(
                                                child: Image.network(
                                                    'https://lyon-jo.com/' +
                                                        iD_Passport),
                                                width: _width * .7,
                                                height: _height / 6,
                                              )
                                        : Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                            width: _width * .7,
                                            height: _height / 6,
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  height: _height * .02,
                                ),
                                GestureDetector(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: _image2 == null
                                        ? license == ''
                                            ? Container(
                                                )
                                            : SizedBox(
                                                child: Image.network(
                                                    'https://lyon-jo.com/' +
                                                        license),
                                                width: _width * .7,
                                                height: _height / 6,
                                              )
                                        : Image.file(
                                            _image2!,
                                            fit: BoxFit.cover,
                                            width: _width * .7,
                                            height: _height / 6,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _height * .05,
                            ),
                            Visibility(
                              visible: isSavedButton,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: buttonSmall(
                                    context: context,
                                    text: "save".tr,
                                    function: () async {
                                      setState(() {
                                        check = false;
                                        showCircleLoading = true;
                                      });
                                      updateInformation();
                                      if (_formKey.currentState!.validate()) {}
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
