import 'package:flutter/material.dart';
import 'package:lyon/shared/styles/colors.dart';

class CustomTextFormFeild extends StatelessWidget {
  const CustomTextFormFeild({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icons,
    this.readOnly = false,
    this.onPressed,
    this.validator, required this.isPhone,

  });

  final TextEditingController controller;
  final String? hintText;
  final Widget? icons;
  final bool? readOnly;
  final Function()? onPressed;
  final String? Function(String?)? validator;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength:isPhone ? 10 : null,
        validator: validator,
        onTap: onPressed,
        controller: controller,
        readOnly: readOnly!,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: icons,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: secondaryColor1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: secondaryColor1),
            borderRadius: BorderRadius.circular(10),
          ),
          label: Text(hintText!),
        ),
      ),
    );
  }
}
