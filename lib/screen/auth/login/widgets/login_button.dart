
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lyon/screen/auth/login/cubit/login_cubit.dart';
import 'package:lyon/v_done/utils/const.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.initialPhoneNumber,
    required this.phoneController,
    required this.passwordController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final PhoneNumber initialPhoneNumber;
  final TextEditingController phoneController;
  final TextEditingController passwordController;

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
          shadowColor: Colors.black,
          foregroundColor: Colors.yellow,
          
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<LoginCubit>().login(
                  countryCode: initialPhoneNumber.dialCode!,
                  phoneNumber: phoneController.text,
                  password: passwordController.text,
                  language: 0, // Adjust based on your app logic
                );
          }
        },
        child: Text("login".tr),
      ),
    );
  }
}
