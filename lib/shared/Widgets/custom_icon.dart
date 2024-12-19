// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.3),
                offset: const Offset(0, 0),
                blurRadius: 30,
              ),
            ],
          ),
          child: InnerShadow(
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(.3),
                offset: const Offset(10, 5),
                blurRadius: 10,
              ),
            ],
            child: SvgPicture.asset(
              icon,
              width: MediaQuery.of(context).size.width * .2,
            ),
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        InnerShadow(
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(.3),
              offset: const Offset(10, 5),
              blurRadius: 10,
            ),
          ],
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style:  TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * .05,
              ),
            ),
          ),
        )
      ],
    );
  }
}
