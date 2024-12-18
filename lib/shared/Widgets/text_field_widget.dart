// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lyon/shared/styles/colors.dart';

Widget textFieldWidgetWithoutFilled(
    {required BuildContext context,
    required String hintText,
    required Widget icons,
    required bool obscureText,
    bool checkLength = false,
    bool checkEmail = false,
    String textValidatorEmail = "Please Enter Correct Email",
    String textValidatorEmpty = "",
    String textValidatorLength = "",
    int maxLines = 1,
    required TextInputType type,
    TextCapitalization? capitalLowercase,
    required TextEditingController controller}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
    child: TextFormField(
      inputFormatters: [
        // FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s")),
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return textValidatorEmpty;
        } else if (checkLength) {
          if (value.length < 8) {
            return "password_must_be_over_8_characters".tr;
          }
        } else if (checkEmail) {
          return RegExp(
                      // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                  .hasMatch(value)
              ? null
              : textValidatorEmail;
        }
        return null;
      },
      controller: controller,
      keyboardType: type,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 18.0),
      cursorColor: Colors.black,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: icons,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget textFieldWidgetWithoutFilledCompany(
    {required BuildContext context,
    required String hintText,
    required Widget icons,
    required bool obscureText,
    bool checkLength = false,
    bool checkEmail = false,
    String textValidatorEmail = "Please Enter Correct Email",
    String textValidatorEmpty = "",
    String textValidatorLength = "",
    required TextInputType type,
    TextCapitalization? capitalLowercase,
    required TextEditingController controller}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return textValidatorEmpty;
        } else if (checkLength) {
          if (value.length < 8) {
            return "password_must_be_over_8_characters".tr;
          }
        } else if (checkEmail) {
          return RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                  .hasMatch(value)
              ? null
              : textValidatorEmail;
        }
        return null;
      },
      controller: controller,
      keyboardType: type,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 18.0),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: icons,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget textFieldWidgetWithoutFilledWithEditFunction(
    {required BuildContext context,
    required String hintText,
    required Widget icons,
    required bool obscureText,
    bool readOnly = false,
    bool checkLength = false,
    bool checkEmail = false,
    String textValidatorEmail = "Please Enter Correct Email",
    String textValidatorEmpty = "",
    String textValidatorLength = "",
    required TextInputType type,
    required TextEditingController controller,
    required Function editFunction}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
    child: TextFormField(
      onChanged: (text) => editFunction(),
      validator: (value) {
        if (value!.isEmpty) {
          return textValidatorEmpty;
        } else if (checkLength) {
          if (value.length < 8) {
            return "password_must_be_over_8_characters".tr;
          }
        } else if (checkEmail) {
          return RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                  .hasMatch(value)
              ? null
              : textValidatorEmail;
        }
        return null;
      },
      readOnly: readOnly,
      controller: controller,
      keyboardType: type,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 18.0),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: icons,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget textFieldWidgetWithoutFilledDateWithEditFunction(
    {required BuildContext context,
    required String hintText,
    required Widget icons,
    required Function fun,
    bool checkLength = false,
    bool checkEmail = false,
    String textValidatorEmail = "Please Enter Correct Email",
    String textValidatorEmpty = "",
    String textValidatorLength = "",
    required TextEditingController controller}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return textValidatorEmpty;
        } else {
          return null;
        }
      },
      onTap: () => fun(),
      controller: controller,
      showCursor: true,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 18.0),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: icons,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget textFieldWidgetWithoutFilledDateSmallWithEditFunction(
    {required BuildContext context,
    required String hintText,
    required Widget icons,
    required Function fun,
    bool checkLength = false,
    bool checkEmail = false,
    String textValidatorEmail = "Please Enter Correct Email",
    String textValidatorEmpty = "",
    String textValidatorLength = "",
    required TextEditingController controller}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 200, minHeight: 50),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return textValidatorEmpty;
        } else {
          return null;
        }
      },
      onTap: () => fun(),
      controller: controller,
      showCursor: true,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 18.0),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: icons,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget textFieldWidgetWithoutFilledWithFunction(
    {required BuildContext context,
    required String hintText,
    required Widget icons,
    required Function fun,
    bool checkLength = false,
    bool checkEmail = false,
    String textValidatorEmail = "Please Enter Correct Email",
    String textValidatorEmpty = "",
    String textValidatorLength = "",
    required TextEditingController controller}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return textValidatorEmpty;
        } else {
          return null;
        }
      },
      onTap: () => fun(),
      controller: controller,
      showCursor: true,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 18.0),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: icons,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget textFieldWidgetWithoutFilledWithFunctionSmall(
    {required BuildContext context,
    required String hintText,
    required Widget icons,
    required Function fun,
    bool checkLength = false,
    bool checkEmail = false,
    String textValidatorEmail = "Please Enter Correct Email",
    String textValidatorEmpty = "",
    String textValidatorLength = "",
    required TextEditingController controller}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return textValidatorEmpty;
        } else {
          return null;
        }
      },
      onTap: () => fun(),
      controller: controller,
      showCursor: true,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 16.0),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        prefixIcon: icons,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 15),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget textFieldWidgetWithoutFilledSmall(
    {required BuildContext context,
    required String hintText,
    required bool obscureText,
    bool checkLength = false,
    bool checkEmail = false,
    String textValidatorEmail = "Please Enter Correct Email",
    String textValidatorEmpty = "",
    String textValidatorLength = "",
    required TextInputType type,
    required TextEditingController controller}) {
  return ConstrainedBox(
    constraints:
        const BoxConstraints(minWidth: double.infinity / 2, minHeight: 50),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return textValidatorEmpty;
        } else if (checkLength) {
          if (value.length < 8) {
            return "password_must_be_over_8_characters".tr;
          }
        } else if (checkEmail) {
          return RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                  .hasMatch(value)
              ? null
              : textValidatorEmail;
        }
        return null;
      },
      controller: controller,
      keyboardType: type,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 18.0),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget textFieldWidgetWithoutFilledSmallWithEditFunction(
    {required BuildContext context,
    required String hintText,
    required bool obscureText,
    bool checkLength = false,
    bool checkEmail = false,
    String textValidatorEmail = "Please Enter Correct Email",
    String textValidatorEmpty = "",
    String textValidatorLength = "",
    required Function editFunction,
    required TextInputType type,
    required TextEditingController controller}) {
  return ConstrainedBox(
    constraints:
        const BoxConstraints(minWidth: double.infinity / 2, minHeight: 50),
    child: TextFormField(
      onChanged: (val) => editFunction(),
      validator: (value) {
        if (value!.isEmpty) {
          return textValidatorEmpty;
        } else if (checkLength) {
          if (value.length < 8) {
            return "password_must_be_over_8_characters".tr;
          }
        } else if (checkEmail) {
          return RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                  .hasMatch(value)
              ? null
              : textValidatorEmail;
        }
        return null;
      },
      controller: controller,
      keyboardType: type,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 18.0),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: secondaryColor1, width: 1.0)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: secondaryColor1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

Widget textFieldWidgetWithoutFilledMoreLineAndMethod(
    {required BuildContext context,
    required String hintText,
    required bool boolData,
    required bool obscureText,
    required TextInputType type,
    required TextEditingController controller}) {
  return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
        child: TextFormField(
          controller: controller,
          keyboardType: type,
          onTap: () {
            setState(() {
              boolData = true;
            });
          },
          maxLines: 3,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.done,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 18.0),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: secondaryColor1, width: 1.0)),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: secondaryColor1),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: secondaryColor1),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: secondaryColor1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  });
}

Widget textFieldWidgetWithoutFilledBlackBorder(
    {required BuildContext context,
    required String hintText,
    required Widget icons,
    required bool obscureText,
    required FormFieldValidator validate,
    required TextInputType type,
    required TextEditingController controller}) {
  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: double.infinity),
    child: Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: validate,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.done,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 18.0),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          prefixIcon: icons,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 2.0)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}
