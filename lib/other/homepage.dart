// import 'package:flutter/material.dart';
// import 'package:flutter_carousel_slider/carousel_slider.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:lyon/amount_controller.dart/amount_controller.dart';
// import 'package:lyon/screen/auth/signup/sigup_page.dart';
// import 'package:lyon/other/rental.dart';
// import 'package:lyon/shared/Widgets/custom_icon.dart';
// import 'package:lyon/v_done/utils/app_helper.dart';
// import '../shared/mehod/switch_sreen.dart';
// import 'select_multi_trip.dart';
// import 'select_one_trip.dart';

// class HomeScreen extends StatefulWidget {
//   final int numberIndex;
//   final bool? isGuest;
//   final String? name;

//   HomeScreen({super.key, required this.numberIndex, this.name, this.isGuest});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController tabController;
//   bool isLoading = true;
//   var blacklist;
//   var remainingAmount = 0;
//   final AmountController amountController = Get.find();

//   @override
//   void initState() {
//     super.initState();

//     tabController = TabController(length: 1, vsync: this);
//     tabController.index = widget.numberIndex;

//     remainingAmount = amountController.amount;

//     AppHelper.reviewApp();
//     widget.isGuest == false? AppHelper.checkBlackList(
//       onLoadingComplete: () {
//         setState(() {
//           isLoading = false;
//         });
//       },
//       onSuccess: (blacklistResult, remaining) {
//         setState(() {
//           blacklist = blacklistResult;
//           remainingAmount = remaining;
//         });
//         amountController.setAmount(remaining);
//         GetStorage().remove('remainingAmount');
//         GetStorage().write('remainingAmount', remaining);
//       },
//     ): setState(() {
//           isLoading = false;
//         });
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _width = MediaQuery.of(context).size.width;
//     final _height = MediaQuery.of(context).size.height;

//     return DefaultTabController(
//       length: 1,
//       initialIndex: 0,
//       child: Column(
//         children: [
//           SizedBox(
//             height: _height * .2,
//             width: _width,
//             child: CarouselSlider.builder(
//               unlimitedMode: true,
//               autoSliderDelay: const Duration(seconds: 3),
//               keepPage: true,
//               enableAutoSlider: true,
//               autoSliderTransitionTime: const Duration(seconds: 2),
//               itemCount: 8,
//               slideBuilder: (int index) => Image.asset(
//                 "assets/images/image$index.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           SizedBox(
//             width: _width,
//             height: _height * 0.7,
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : GridView(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 0,
//                       mainAxisExtent: 140,
//                       crossAxisSpacing: 0.9,
//                     ),
//                     padding: EdgeInsets.zero,
//                     children: [
//                       _buildGridItem(
//                         context,
//                         "assets/icons/rental.svg",
//                         "rental".tr,
//                         const Rental(),
//                       ),
//                       _buildGridItem(
//                         context,
//                         "assets/icons/trip.svg",
//                         "trip".tr,
//                         const SelectOneTrip(),
//                       ),
//                       _buildGridItem(
//                         context,
//                         "assets/icons/program.svg",
//                         "tourism_program".tr,
//                         const SelectMultiTrip(),
//                       ),
//                     ],
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGridItem(BuildContext context, String icon, String title, Widget page) {
//     return GestureDetector(
//       onTap: () {
//         if (widget.isGuest == true) {
//           push(context, const SignupPage());
//           return;
//         }
//         if (blacklist == "1") {
//           _showDialog(context, "error".tr, "you_are_blacklisted".tr);
//         } else if (remainingAmount > 7) {
//           _showDialog(context, "warning".tr, "please_pay_the_amounts_due".tr);
//         } else {
//           push(context, page);
//         }
//       },
//       child: CustomIcon(icon: icon, title: title),
//     );
//   }

//   void _showDialog(BuildContext context, String title, String content) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(content),
//           actions: <Widget>[
//             TextButton(
//               child: Text("ok".tr),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lyon/amount_controller.dart/amount_controller.dart';
import 'package:lyon/screen/auth/signup/sigup_page.dart';
import 'package:lyon/other/rental.dart';
import 'package:lyon/shared/Widgets/custom_icon.dart';
import 'package:lyon/v_done/utils/app_helper.dart';
import '../shared/mehod/switch_sreen.dart';
import 'select_multi_trip.dart';
import 'select_one_trip.dart';

class HomeScreen extends StatefulWidget {
  final int numberIndex;
  final bool? isGuest;
  final String? name;

  HomeScreen({super.key, required this.numberIndex, this.name, this.isGuest});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isLoading = true;
  var blacklist;
  var remainingAmount = 0;
  final AmountController amountController = Get.find();

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 1, vsync: this);
    tabController.index = widget.numberIndex;

    remainingAmount = amountController.amount;

    AppHelper.reviewApp();
    if (widget.isGuest == false) {
      AppHelper.checkBlackList(
        onLoadingComplete: () {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        },
        onSuccess: (blacklistResult, remaining) {
          if (mounted) {
            setState(() {
              blacklist = blacklistResult;
              remainingAmount = remaining;
            });
          }
          amountController.setAmount(remaining);
          GetStorage().remove('remainingAmount');
          GetStorage().write('remainingAmount', remaining);
        },
      );
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 1,
      initialIndex: 0,
      child: Column(
        children: [
          SizedBox(
            height: _height * .2,
            width: _width,
            child: CarouselSlider.builder(
              unlimitedMode: true,
              autoSliderDelay: const Duration(seconds: 3),
              keepPage: true,
              enableAutoSlider: true,
              autoSliderTransitionTime: const Duration(seconds: 2),
              itemCount: 8,
              slideBuilder: (int index) => Image.asset(
                "assets/images/image$index.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: _width,
            height: _height * 0.7,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      mainAxisExtent: 140,
                      crossAxisSpacing: 0.9,
                    ),
                    padding: EdgeInsets.zero,
                    children: [
                      _buildGridItem(
                        context,
                        "assets/icons/rental.svg",
                        "rental".tr,
                        const Rental(),
                      ),
                      _buildGridItem(
                        context,
                        "assets/icons/trip.svg",
                        "trip".tr,
                        const SelectOneTrip(),
                      ),
                      _buildGridItem(
                        context,
                        "assets/icons/program.svg",
                        "tourism_program".tr,
                        const SelectMultiTrip(),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String icon, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        if (widget.isGuest == true) {
          push(context, const SignupPage());
          return;
        }
        if (blacklist == "1") {
          _showDialog(context, "error".tr, "you_are_blacklisted".tr);
        } else if (remainingAmount > 7) {
          _showDialog(context, "warning".tr, "please_pay_the_amounts_due".tr);
        } else {
          push(context, page);
        }
      },
      child: CustomIcon(icon: icon, title: title),
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text("ok".tr),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

