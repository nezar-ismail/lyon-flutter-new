// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class CustomIcon extends StatelessWidget {
  String icon;

  String title;

  CustomIcon({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                // BoxShadow(
                //   color: Colors.grey.withOpacity(0.3),
                //   spreadRadius: 3,
                //   blurRadius: 3,
                //   offset: const Offset(0,
                //       3), // changes position of shadow
                // ),
              ]),
          child: Column(
            children: [
              SvgPicture.asset(
                icon,
                width: 60,
                //  color: secondaryColor1,
              ),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
