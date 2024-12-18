import 'package:flutter/material.dart';
import '../../shared/styles/colors.dart';

class ViewImage extends StatelessWidget {
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
