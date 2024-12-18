import 'package:flutter/material.dart';
import 'package:lyon/shared/styles/colors.dart';

BoxDecoration screenDecoration = const BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [Colors.white, colorPrimary],
));

Widget logoScreen({required BuildContext context}) {
  return Image.asset(
    "assets/images/logo.png",
    width: MediaQuery.of(context).size.width * 0.50,
    height: MediaQuery.of(context).size.height / 7,
  );
}

Widget drawerWithText({required BuildContext context, required String text}) {
  return Row(children: <Widget>[
    Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: const Divider(
            color: Colors.black,
            height: 36,
          )),
    ),
    Text(text),
    Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 10.0),
          child: const Divider(
            color: Colors.black,
            height: 36,
          )),
    ),
  ]);
}

Widget operation({
  required BuildContext context,
  required Widget icon,
  required Function fun,
}) {
  return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
    return GestureDetector(
      onTap: () => fun(),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: icon,
        ),
      ),
    );
  });
}
