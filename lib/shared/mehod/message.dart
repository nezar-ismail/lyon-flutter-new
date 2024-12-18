import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lyon/shared/styles/colors.dart';

showMessage({
  required BuildContext context,
  required String text,
  Color? backgroundColor,
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.SNACKBAR,
    backgroundColor: backgroundColor ?? secondaryColor1,
    textColor: Colors.white,
    fontSize: 22.0,
  );
}

showPopup(
    {required BuildContext context,
    required String question,
    required Function funAccept,
    required Function funReject}) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.11,
            child: Column(
              children: [
                Text(
                  question,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => funReject(),
                      child: Text(
                        "no".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(secondaryColor1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                    ),
                    ElevatedButton(
                      onPressed: () => funAccept(),
                      child: Text(
                        "yes".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(secondaryColor1),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}
