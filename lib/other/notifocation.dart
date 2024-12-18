// import 'package:flutter/material.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:lyon/shared/Widgets/appbar.dart';
// import 'package:lyon/shared/styles/colors.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({Key? key}) : super(key: key);

//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   List<bool> image = [false, false, false];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: AppBars(
//           withIcon: false,
//           context: context,
//           text: "notification".tr,
//           canBack: true,
//         ),
//         body: ListView.builder(
//           itemBuilder: (_, index) {
//             return GestureDetector(
//               onTap: () {
//                 // setState(() {
//                 //   image[index] = true;
//                 // });
//                 // showDialog(
//                 //   context: context,
//                 //   builder: (BuildContext context) {
//                 //     return SizedBox(
//                 //       child: AlertDialog(
//                 //         title: Text("message".tr),
//                 //         content: SizedBox(
//                 //           height: MediaQuery.of(context).size.height * .50,
//                 //           child: ListView(
//                 //             shrinkWrap: true,
//                 //             children: [
//                 //           const Text(
//                 //                 'Welcome To Lyon Group',
//                 //               ),
//                 //               Image.asset(
//                 //                 'assets/images/lyon.jpeg',
//                 //               ),
//                 //               const Text(
//                 //                 'Welcome To Lyon Group',
//                 //               ),
//                 //             ],
//                 //           ),
//                 //         ),
//                 //         actions: <Widget>[
//                 //           // ignore: deprecated_member_use
//                 //           FlatButton(
//                 //             child: Text("ok".tr),
//                 //             onPressed: () {
//                 //               Navigator.of(context).pop();
//                 //             },
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     );
//                 //   },
//                 // );
//               },
//               child: Card(
//                 child: ListTile(
//                   leading: image[index] == true
//                       ? Image.asset(
//                           'assets/images/lyon.jpeg',
//                           width: 50,
//                           height: 50,
//                         )
//                       : const Icon(Icons.title),
//                   title: const Text('title'),
//                   subtitle: const Text('message'),
//                   trailing: image[index] == true
//                       ? null
//                       : Text('\u2022',
//                           style: TextStyle(
//                               color: Colors.red.shade700, fontSize: 50)),
//                 ),
//               ),
//             );
//           },
//           shrinkWrap: true,
//           itemCount: 3,
//         ));
//   }
// }
