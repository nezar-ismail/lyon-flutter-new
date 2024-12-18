import 'package:dio/dio.dart' as prefix;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lyon/check_out_controller.dart/check_out_controller.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/tourism_check_out_controller.dart/tourism_check_out_controller.dart';
import 'package:lyon/trip_check_out_controller.dart/trip_check_out_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api.dart';

class UploadPassportPhoto extends StatefulWidget {
  final String title;
  final String whereYouComingFrom;

  const UploadPassportPhoto({
    super.key,
    required this.title,
    required this.whereYouComingFrom,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UploadPassportPhotoState createState() => _UploadPassportPhotoState();
}

class _UploadPassportPhotoState extends State<UploadPassportPhoto> {
  final ImagePicker _imagePicker = ImagePicker();
  File? image1;
  bool isLastItem = false;
  bool isImageNull = false;
  var dio = prefix.Dio();
  bool isLoadingButton = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //  BackButtonInterceptor.add(myInterceptor);
  }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  // showMessage(context: context, text: "you_must_upload_image".tr);
  // return true;
  // }

  @override
  dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  postImages(File? frontImage) async {
    String apiUrl = ApiApp.uploadUserDocuments;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedToken = prefs.getString('access_token');
    String frontImage0 = frontImage!.path.split('/').last;
    var formData = prefix.FormData.fromMap({
      'token': sharedToken,
      'type': widget.title.toString(),
      'image': await prefix.MultipartFile.fromFile(frontImage.path,
          filename: frontImage0),
      "mobile": "1"
    });

    await dio.post(apiUrl, data: formData);
  }

  @override
  Widget build(BuildContext context) {
    CheckOutController controller = Get.find();
    TripCheckOutController tripController = Get.find();
    TourismCheckOutController tourismCheckOutController = Get.find();
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          backgroundColor: secondaryColor1,
          centerTitle: true,
          title: Text(
            widget.title.tr,
          ),
          automaticallyImplyLeading: false,
        ),
        body: isLoadingButton
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
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
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                        Text(widget.title),
                                      ],
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.file(
                                    image1!,
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                  ),
                                )),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: isImageNull,
                        child: Text(
                          'please_upload_image'.tr,
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
                              if (widget.title ==
                                      "upload_passport_id_photos".tr &&
                                  widget.whereYouComingFrom ==
                                      "comingFromRental") {
                                controller.togglePassportVariableToFalse();
                                // String? tempVar =
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
                              } else if (widget.title ==
                                      "upload_ticket_photo".tr &&
                                  widget.whereYouComingFrom ==
                                      "comingFromRental") {
                                controller.toggleTicketVariableToFalse();
                                // String? tempVar =
                                //     await controller.callTheUserDocumentsAPI();
                                // if (tempVar == "All images are attached" &&
                                //     controller
                                //             .askUserForTicketUploading.value ==
                                //         false) {
                                //   //here I am supposed to
                                //   controller.displayAThankfulMessage.value =
                                //       true;
                                // }
                                // print("Here is the tempVariable: $tempVar");
                              } else if (widget.title ==
                                      "upload_ticket_photo".tr &&
                                  widget.whereYouComingFrom ==
                                      "comingFromTrip") {
                                tripController.toggleTicketVariable();

                                //Here I am supposed to call a function that's in the controller. -this function- hides the ticket button.
                              } else if (widget.title ==
                                      "upload_passport_id_photos".tr &&
                                  widget.whereYouComingFrom ==
                                      "comingFromTrip") {
                                tripController.togglePassportVariable();

                                //Here I am supposed to call a function that's in the controller. -this function- hides the passport button.
                              } else if (widget.title ==
                                      "upload_passport_id_photos".tr &&
                                  widget.whereYouComingFrom ==
                                      "comingFromTourism") {
                                tourismCheckOutController
                                    .togglePassportVariableToFalse();
                              } else if (widget.title ==
                                      "upload_ticket_photo".tr &&
                                  widget.whereYouComingFrom ==
                                      "comingFromTourism") {
                                //here I am supposed to create a variable in the controller -which's--> responsible for the ticket's visibility.
                                tourismCheckOutController
                                    .toggleTicketVariableToFalse();
                              }
                              await postImages(image1).whenComplete(() {
                                //here I am supposed to call the function which's in the controller -that--> checks whether everything is inserted -to--> display a ThankYou! message.
                                showMessage(
                                    context: context,
                                    text: "pictures_have_been_saved".tr);
                                Navigator.pop(context, true);
                              });
                            }
                          }),
                    ],
                  ),
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
          isDestructiveAction: true,
          child: Text('delete_photo'.tr),
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
          child: Text('choose_image_gallery'.tr),
        ),
        CupertinoActionSheetAction(
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
          child: Text('choose_image'.tr),
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
