import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get_storage/get_storage.dart';
import 'package:lyon/amount_controller.dart/amount_controller.dart';
import 'package:lyon/shared/styles/colors.dart';
//import 'dart:math' as math;

class AppBars extends AppBar {
  AppBars({
    bool? isGuest = false,
    super.key,
    required bool withIcon,
    required String text,
    required BuildContext context,
    bool canBack = false,
    bool endDrawer = false,
  }) : super(
          backgroundColor: secondaryColor1,

          title: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
          actions: [
            endDrawer
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: GetBuilder<AmountController>(
                      builder: (controller) {
                        if (isGuest == true) {
                          return const Text('');
                        } else {
                          return Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            'amount'.tr +
                                ' = ${controller.amount}', //it was ${GetStorage.read('')}
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          );
                        }
                      },
                    )),
                  )
                : Container(),
          ],
          leading: withIcon
              ? Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.sort_outlined,
                      size: 30,
                      color: colorPrimary,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                )
              : canBack
                  ? IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        // size: 30,
                      ),
                      color: Colors.white,
                    )
                  : Container(),
          // actions: [
          //   withIcon
          //       ? IconButton(
          //           onPressed: () {
          //             push(context, const NotificationScreen());
          //             //Notification Screen
          //           },
          //           icon: Badge(
          //             animationType: BadgeAnimationType.slide,
          //             badgeContent: const Text('3'),
          //             child: const Icon(Icons.notifications),
          //           ))
          //       : Container(),
          // ],
        ) {
    _setupController();
  }

  void _setupController() {
    // ignore: unused_local_variable
    final AmountController amountController = Get.find();
    amountController.checkAmount();
  }
}

class AppBarWithNotification extends AppBar {
  AppBarWithNotification({
    super.key,
    required bool withIcon,
    required String text,
    required BuildContext context,
    bool canBack = false,
    bool doubleBack = false,
  }) : super(
          backgroundColor: secondaryColor1,
          title: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                //  Navigator.popUntil(context, (route) => print(route));
                Navigator.pop(context);
                if (doubleBack) Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              )),

          // actions: [
          //   withIcon
          //       ? IconButton(
          //           onPressed: () {
          //             push(context, const NotificationScreen());
          //             //Notification Screen
          //           },
          //           icon: Badge(
          //             animationType: BadgeAnimationType.slide,
          //             badgeContent: const Text('3'),
          //             child: const Icon(Icons.notifications),
          //           ))
          //       : Container(),
          // ],
        );
}
