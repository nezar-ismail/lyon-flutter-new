import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripsOperations extends StatelessWidget {
  const TripsOperations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        ElevatedButton(
            onPressed: () {}, child: Text("Add more Trip".tr)),
        ElevatedButton(
            onPressed: () {}, child: Text("delete".tr)),
        ElevatedButton(
            onPressed: () {}, child:  Text("submit".tr)),
      ]),
    );
  }
}
