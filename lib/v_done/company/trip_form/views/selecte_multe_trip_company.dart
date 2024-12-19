import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lyon/model/company_model/trips_model.dart';
import 'package:lyon/v_done/company/trip_form/cubit/nav_cubit.dart';
import 'package:lyon/v_done/company/trip_form/cubit/trip_form_cubit.dart';
import 'package:lyon/v_done/company/trip_form/widgets/project_name.dart';
import 'package:lyon/v_done/company/trip_form/widgets/trip_form.dart';
import 'package:lyon/shared/styles/colors.dart';

class SelecteMulteTripCompany extends StatelessWidget {
  SelecteMulteTripCompany({
    super.key,
    required this.type,
  });

  final String type;
  final ValueNotifier<List<ListElement>> trips = ValueNotifier([ListElement()]);
  final TextEditingController projectName = TextEditingController();
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TripProgramCubit()),
        BlocProvider(create: (_) => TripNavigationCubit()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: secondaryColor1,
          foregroundColor: Colors.white,
          title: Text("Trips_Program_Form".tr),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<TripProgramCubit, TripFormState>(
            builder: (context, state) {
              if (state is TripFormLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is TripFormInitial) {
                return ProjectName(projectName: projectName);
              }
              return Column(
                children: [
                  const SizedBox(height: 10),
                  BlocBuilder<TripNavigationCubit, int>(
                    builder: (context, currentPage) {
                      return ValueListenableBuilder<List<ListElement>>(
                        valueListenable: trips,
                        builder: (context, value, _) {
                          return EasyStepper(
                            maxReachedStep: 10,
                            activeStep: currentPage,
                            activeStepBorderColor: secondaryColor1,
                            activeStepBackgroundColor: Colors.yellow,
                            activeStepIconColor: secondaryColor1,
                            activeStepTextColor: secondaryColor1,
                            finishedStepBackgroundColor: secondaryColor1,
                            finishedStepBorderColor: secondaryColor1,
                            finishedStepTextColor: secondaryColor1,
                            finishedStepIconColor: Colors.white,
                            stepBorderRadius: 10,
                            stepRadius: 30,
                            showStepBorder: true,
                            steps: List.generate(value.length, (index) {
                              return EasyStep(
                                icon: const Icon(Icons.location_on),
                                title: '${'Trip'.tr} ${index + 1}',
                              );
                            }),
                          );
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 700,
                            child: BlocListener<TripNavigationCubit, int>(
                              listener: (context, currentPage) {
                                if (currentPage >= trips.value.length) {
                                  trips.value.add(ListElement());
                                }
                                trips.value =
                                    List.from(trips.value); // Notify listeners
                                pageController.animateToPage(
                                  currentPage,
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.easeInQuad,
                                );
                              },
                              child: ValueListenableBuilder<List<ListElement>>(
                                valueListenable: trips,
                                builder: (context, value, _) {
                                  return PageView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    controller: pageController,
                                    itemCount: value.length,
                                    itemBuilder: (context, index) {
                                      if (index >= value.length) {
                                        value.add(ListElement());
                                        trips.value = List.from(
                                            value); // Notify listeners
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TripForm(
                                          trip: value[index],
                                          onValidate: (trip) {
                                            value[index] = trip;
                                            trips.value = List.from(
                                                value); // Notify listeners
                                          },
                                          vehicleType: type,
                                          trips: value,
                                          projectName: projectName,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
