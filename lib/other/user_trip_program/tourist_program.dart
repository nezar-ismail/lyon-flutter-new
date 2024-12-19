import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lyon/other/user_trip_program/model/trip.dart';
import 'package:lyon/other/user_trip_program/widgets/user_trip_form.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'package:lyon/v_done/company/trip_form/cubit/nav_cubit.dart';
import 'package:lyon/v_done/company/trip_form/cubit/trip_form_cubit.dart';

class SelecteMulteTripUser extends StatelessWidget {
  SelecteMulteTripUser({
    super.key,
    required this.type,
    required this.image,
    required this.price,
  });

  final String image;
  final String price;
  final String type;
  final ValueNotifier<List<UserTrips>> trips =
      ValueNotifier([const UserTrips(), const UserTrips()]);
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
              return Column(
                children: [
                  const SizedBox(height: 10),
                  BlocBuilder<TripNavigationCubit, int>(
                    builder: (context, currentPage) {
                      return ValueListenableBuilder<List<UserTrips>>(
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
                            height: 500,
                            child: BlocListener<TripNavigationCubit, int>(
                              listener: (context, currentPage) {
                                if (currentPage >= trips.value.length) {
                                  trips.value.add(const UserTrips());
                                }
                                trips.value =
                                    List.from(trips.value); // Notify listeners
                                pageController.animateToPage(
                                  currentPage,
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.easeInQuad,
                                );
                              },
                              child: ValueListenableBuilder<List<UserTrips>>(
                                valueListenable: trips,
                                builder: (context, value, _) {
                                  return PageView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: pageController,
                                    itemCount: value.length,
                                    itemBuilder: (context, index) {
                                      if (index >= value.length) {
                                        value.add(const UserTrips());
                                        trips.value = List.from(
                                            value); // Notify listeners
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: UserTripForm(
                                          image: image,
                                          trip: value[index],
                                          onValidate: (trip) {
                                            value[index] = trip;
                                            trips.value = List.from(
                                                value); // Notify listeners
                                          },
                                          vehicleType: type,
                                          trips: value,
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
