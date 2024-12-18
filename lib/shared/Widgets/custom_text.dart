import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final Alignment alignment;
  final FontWeight? fontWeight;
  final int? maxLine;
  final double? height;

  const CustomText(
      {super.key,
      this.text = '',
      this.size = 15.0,
      this.color = Colors.black,
      this.alignment = Alignment.topLeft,
      this.fontWeight,
      this.maxLine=1,
      this.height = 1.0});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      maxLines: maxLine,
      style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: fontWeight,
          height: height),
    );
  }
}
