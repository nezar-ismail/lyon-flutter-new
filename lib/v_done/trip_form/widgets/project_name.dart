import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lyon/v_done/trip_form/cubit/trip_form_cubit.dart';
import 'package:lyon/v_done/trip_form/widgets/text_feild_form.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/utils/custom_snackbar.dart';

class ProjectName extends StatelessWidget {
  const ProjectName({
    super.key,
    required this.projectName,
  });

  final TextEditingController projectName;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "please_enter_project_name".tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFormFeild(
            controller: projectName,
            hintText: "project_name".tr,
            icons: const Icon(
              Icons.text_fields_outlined,
            ), isPhone: false,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor1,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (projectName.text.isNotEmpty) {
                context
                    .read<TripProgramCubit>()
                    .goToProgram();
              } else {
                customSnackBar(context, "please_enter_project_name".tr,
                    "Required".tr);
              }
            },
            child: Text("next".tr),
          ),
        ]);
  }
}
