import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lyon/shared/styles/colors.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.items,
    required this.hintTxt,
    required this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
  });
  final List<dynamic> items;
  final String hintTxt;
  final TextEditingController controller;

  final FormFieldValidator<dynamic>? validator;
  final Function(dynamic)? onChanged;
  final Function(dynamic)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownSearch(
        autoValidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onSaved: (val) {
          controller.text = val.toString();
          if (onSaved != null) {
            onSaved!(val);
          }
        },
        onChanged: (val) {
          controller.text = val.toString();

          if (onChanged != null) {
            onChanged!(val);
          }
        },
        selectedItem: controller.text.isEmpty ? null : controller.text,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: secondaryColor1,
            ),
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: secondaryColor1,
            ),
            hintText: hintTxt,
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor1),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor1),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            isDense: true,
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
          ),
        ),
        popupProps: const PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                color: secondaryColor1,
              ),
            ),
          ),
        ),
        items: items,
      ),
    );
  }
}
