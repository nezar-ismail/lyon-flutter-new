import 'package:flutter/material.dart';
import 'package:lyon/shared/styles/colors.dart';

Widget button(
    {required BuildContext context,
    required String text,
    required Function function,
    Color color = colorPrimary}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.8,
    height: MediaQuery.of(context).size.height * 0.06,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        onPressed: () => function(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 20),
          ),
        )),
  );
}

Widget buttonSmall(
    {required BuildContext context,
    required String text,
    required Function function}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.45,
    height: MediaQuery.of(context).size.height * 0.06,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onPressed: () => function(),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        )),
  );
}

Widget buttonSmallLanguage(
    {required BuildContext context,
    required String text,
    required Function function}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 3,
    height: MediaQuery.of(context).size.height * 0.06,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onPressed: () => function(),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 19),
        )),
  );
}

Widget buttonSSmall(
    {required BuildContext context,
    required String text,
    required Function function}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.2,
    height: MediaQuery.of(context).size.height * 0.05,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onPressed: () => function(),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        )),
  );
}

Widget buttonText(
    {required BuildContext context,
    required String text,
    required Function function}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.7,
    height: MediaQuery.of(context).size.height * 0.08,
    child: TextButton(
        onPressed: () => function(),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.amber,
          ),
        )),
  );
}

Widget buttonSocial(
    {required BuildContext context,
    required String image,
    required Function function}) {
  return GestureDetector(
    onTap: () => function(),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(image),
      )),
    ),
  );
}
