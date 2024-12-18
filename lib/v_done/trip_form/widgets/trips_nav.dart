import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripsNav extends StatelessWidget {
  const TripsNav({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.isNextEnabled,
    required this.isPreviousEnabled,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isNextEnabled;
  final bool isPreviousEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isPreviousEnabled ? Colors.white: Colors.grey,
            foregroundColor: Colors.blue,
          ),
          onPressed: isPreviousEnabled ? onPrevious : null,
          icon: const Icon(Icons.arrow_left),
          label: Text("back".tr),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
          ),
          onPressed: onNext,
          icon: const Icon(Icons.arrow_right),
          label:
              isNextEnabled ?  Text("next".tr) : Text("Add_more_Trip".tr),
        ),
      ]),
    );
  }
}
