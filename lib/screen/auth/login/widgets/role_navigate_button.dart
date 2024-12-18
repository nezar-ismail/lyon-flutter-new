
import 'package:flutter/material.dart';
import 'package:lyon/v_done/utils/const.dart';

class RoleNavigatButton extends StatelessWidget {
  const RoleNavigatButton({
    super.key, required this.text,
    required this.onPressed
    , required this.color
  });
  final String text; 
  final VoidCallback onPressed;
  final Color color;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 10),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
          shadowColor: Colors.black,
          foregroundColor: color,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
