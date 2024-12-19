import 'package:flutter/material.dart';
import '../../shared/styles/colors.dart';

class ViewImage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final image;
  const ViewImage({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor1,
      ),
      body: Center(child: Image.file(image)),
    );
  }
}
