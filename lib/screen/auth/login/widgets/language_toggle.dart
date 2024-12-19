
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyon/screen/auth/login/cubit/login_cubit.dart';
import 'package:lyon/v_done/utils/Translate/localization.dart';
import 'package:lyon/v_done/utils/const.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            context
                .read<LoginCubit>()
                .changeLanguage(0); // 0 for English
                  LocalizationService().changeLocale("English");
          },
          child: const Text("English"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            context
                .read<LoginCubit>()
                .changeLanguage(1); // 1 for Arabic
                LocalizationService().changeLocale("Arabic");
          },
          child: const Text("عربي"),
        ),
      ],
    );
  }
}
