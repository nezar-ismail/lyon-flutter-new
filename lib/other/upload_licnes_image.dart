import 'dart:io';
import 'package:dio/dio.dart' as diopackage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lyon/api/api.dart';
import 'package:lyon/check_out_controller.dart/check_out_controller.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadLicnesImage extends StatefulWidget {
  const UploadLicnesImage({super.key});

  @override
  _UploadLicnesImageState createState() => _UploadLicnesImageState();
}

class _UploadLicnesImageState extends State<UploadLicnesImage> {
  final ImagePicker _imagePicker = ImagePicker();
  File? image1;
  // File? image2;
  bool isLastItem = false;
  bool isImageNull = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dio = diopackage.Dio();
  Future? futurePost;
  bool isLoadingButton = false;

  @override
  void initState() {
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    //  BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  // print("BACK BUTTON!"); // Do some stuff.
  // return true;
  // }

  postImages(File? frontImage) async {
    String apiUrl = ApiApp.uploadUserDocuments;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _sharedToken = _prefs.getString('access_token');

    String _frontImage = frontImage!.path.split('/').last;
    var formData = diopackage.FormData.fromMap({
      'token': _sharedToken,
      'userBookingUploadLicense': await diopackage.MultipartFile.fromFile(
          frontImage.path,
          filename: _frontImage),
      "mobile": "1"
    });
    // ignore: unused_local_variable
    var response = await dio.post(apiUrl, data: formData);
  }

  @override
  Widget build(BuildContext context) {
    CheckOutController controller = Get.find();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          backgroundColor: secondaryColor1,
          centerTitle: true,
          title: Text(
            "personal_identification".tr,
          ),
          automaticallyImplyLeading: false,
        ),
        body: isLoadingButton
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : WillPopScope(
                onWillPop: () async {
                  Navigator.pop(context, true);
                  return true;
                },
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
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
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey[800],
                                          ),
                                          Text('front_image'.tr),
                                        ],
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.file(
                                      image1!,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                    ),
                                  )),
                        const SizedBox(
                          height: 20,
                        ),
                        // GestureDetector(
                        //     onTap: () {
                        //       !isLastItem || image2 == null
                        //           ? const Text("")
                        //           : _viewOrDeleteImage(image2!);
                        //     },
                        //     child: !isLastItem || image2 == null
                        //         ? GestureDetector(
                        //             onTap: () => _pickImage2(),
                        //             child: Container(
                        //               decoration: BoxDecoration(
                        //                   color: Colors.grey[200],
                        //                   borderRadius:
                        //                       BorderRadius.circular(20)),
                        //               width: MediaQuery.of(context).size.width *
                        //                   .8,
                        //               height:
                        //                   MediaQuery.of(context).size.height /
                        //                       4,
                        //               child: Column(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.center,
                        //                 children: [
                        //                   Icon(
                        //                     Icons.camera_alt,
                        //                     color: Colors.grey[800],
                        //                   ),
                        //                   Text('back_image'.tr),
                        //                 ],
                        //               ),
                        //             ),
                        //           )
                        //         : ClipRRect(
                        //             borderRadius: BorderRadius.circular(20.0),
                        //             child: Image.file(
                        //               image2!,
                        //               fit: BoxFit.cover,
                        //               width: MediaQuery.of(context).size.width *
                        //                   .8,
                        //               height:
                        //                   MediaQuery.of(context).size.height /
                        //                       4,
                        //             ),
                        //           )),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        Visibility(
                          visible: isImageNull,
                          child: Text(
                            'please_upload_licnes_image'.tr,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        buttonSmall(
                            context: context,
                            text: "save_image".tr,
                            function: () async {
                              if (image1 == null) {
                                setState(() {
                                  isImageNull = true;
                                });
                              } else {
                                setState(() {
                                  isImageNull = false;
                                  isLoadingButton = true;
                                });
                                controller.toggleLicenseVariableToFalse();
                                //  String? tempVar =
                                //     await controller.callTheUserDocumentsAPI();
                                // print("Here is the tempVariable: $tempVar");
                                // if (controller.theUserIsComingOrGoingToAirport
                                //         .value ==
                                //     true) {
                                //   if (tempVar == "All images are attached" &&
                                //       controller.askUserForTicketUploading
                                //               .value ==
                                //           false) {
                                //     controller.displayAThankfulMessage.value =
                                //         true;
                                //   }
                                // } else {
                                //   if (tempVar == "All images are attached") {
                                //     controller.displayAThankfulMessage.value = true;
                                //   }
                                // }
                                print(controller
                                    .askUserForLicenseUploading.value);
                                await postImages(image1).then((value) {
                                  showMessage(
                                      context: context,
                                      text: "pictures_have_been_saved".tr);
                                  Navigator.pop(context, true);
                                  // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>CheckOut(character:widget.isOk)) );
                                });
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ));
  }

  _viewOrDeleteImage(File imageFile) {
    final action = CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.pop(context);
            setState(() {
              // ignore: unnecessary_null_comparison
              imageFile == null;
              isLastItem = false;
            });
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

  // _pickImage2() {
  //   final action = CupertinoActionSheet(
  //     message: Text(
  //       'add_image'.tr,
  //       style: const TextStyle(fontSize: 15.0),
  //     ),
  //     actions: <Widget>[
  //       CupertinoActionSheetAction(
  //         child: Text('choose_image_gallery'.tr),
  //         isDefaultAction: false,
  //         onPressed: () async {
  //           Navigator.pop(context);
  //           XFile? image =
  //               await _imagePicker.pickImage(source: ImageSource.gallery);
  //           if (image != null) {
  //             setState(() {
  //               isLastItem = true;
  //               image2 = File(image.path);
  //             });
  //           }
  //         },
  //       ),
  //       CupertinoActionSheetAction(
  //         child: Text('choose_image'.tr),
  //         isDestructiveAction: false,
  //         onPressed: () async {
  //           Navigator.pop(context);
  //           XFile? image =
  //               await _imagePicker.pickImage(source: ImageSource.camera);
  //           if (image != null) {
  //             setState(() {
  //               isLastItem = true;
  //               image2 = File(image.path);
  //             });
  //           }
  //         },
  //       )
  //     ],
  //     cancelButton: CupertinoActionSheetAction(
  //       child: Text('cancel'.tr),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  //   showCupertinoModalPopup(context: context, builder: (context) => action);
  // }
}
