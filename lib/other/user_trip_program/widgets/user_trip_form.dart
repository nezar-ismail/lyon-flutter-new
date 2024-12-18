import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lyon/other/details_tourist_program.dart';
import 'package:lyon/other/user_trip_program/api/api_service.dart';
import 'package:lyon/other/user_trip_program/cubit/cubit/price_cubit.dart';
import 'package:lyon/other/user_trip_program/cubit/tourist_program_cubit.dart';
import 'package:lyon/other/user_trip_program/model/trip.dart';
import 'package:lyon/v_done/company/trip_form/cubit/nav_cubit.dart';
import 'package:lyon/v_done/company/trip_form/utils/picked_func.dart';
import 'package:lyon/v_done/company/trip_form/widgets/custom_drop_down.dart';
import 'package:lyon/v_done/company/trip_form/widgets/text_feild_form.dart';
import 'package:lyon/v_done/company/trip_form/widgets/trips_nav.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/v_done/utils/custom_log.dart';

// ignore: must_be_immutable
class UserTripForm extends StatelessWidget {
  UserTripForm(
      {super.key,
      required this.onValidate,
      required this.vehicleType,
      required this.trip,
      required this.trips,
      required this.image});

  final Function(UserTrips trip) onValidate;
  ValueNotifier<String> price = ValueNotifier('empty');
  ValueNotifier<String> currency = ValueNotifier('empty');
  String requireTicket = 'empty';
  String image;
  UserTrips trip;
  List<UserTrips> trips;
  final String vehicleType;
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final PriceCubit cubit = PriceCubit();
  @override
  Widget build(BuildContext context) {
    logInfo('init ${trip.toJson()}');
    destinationController.text = trip.destination ?? '';
    timeController.text = trip.time ?? '';
    dateController.text = trip.date ?? '';
    price.value = trip.price.toString();
    currency.value = trip.currency.toString();
    requireTicket = trip.requireTicket.toString();

    return BlocProvider(
      lazy: false,
      create: (context) => TouristProgramCubit(apiService: ApiService())
        ..loadTransportationRoutes(),
      child: BlocBuilder<TouristProgramCubit, TouristProgramState>(
        builder: (context, state) {
          if (state is LoadTransportationRoutesSuccess) {
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  _price(),
                  _buildDestinationDropdown(
                      context, state.items, state.location),
                  _buildDateField(context),
                  _buildTimeField(context),
                  _buildOperation(context, state),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _price() {
    return ValueListenableBuilder(
      valueListenable: price,
      builder: (BuildContext context, String value, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: currency,
                builder: (BuildContext context, String value, Widget? child) {
                  return price.value!= 'empty' && currency.value!= 'empty'&&price.value!= 'null' && currency.value!= 'null' ? Text(
                    '${'price'.tr} : ${price.value} ${currency.value} ',
                    style:
                        const TextStyle(color: Colors.blueAccent, fontSize: 22),
                  ): const SizedBox.shrink();
                })
          ],
        );
      },
    );
  }

  Widget _buildDestinationDropdown(BuildContext context, List<String> items,
      List<Map<String, dynamic>> location) {
    return CustomDropDown(
      controller: destinationController,
      hintTxt: destinationController.text.isEmpty
          ? "  ${"Select_Destination".tr}"
          : "  ${destinationController.text}",
      items: items,
      onChanged: (val) {
        destinationController.text = val.toString();
        price.value = location[items.indexOf(val.toString())]['carPrice'].toString();
        currency.value = location[items.indexOf(val.toString())]['currency'];
        requireTicket =
            location[items.indexOf(val.toString())]['requireTicket'];

        cubit.refreshPrice(price.value, currency.value);
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return CustomTextFormFeild(
      controller: dateController,
      hintText: 'date'.tr,
      icons: const Icon(Icons.date_range),
      readOnly: true,
      onPressed: () async {
        await selectDate(
          context: context,
          dateController: dateController,
          selectedDate: DateTime.now(),
          firstDate: DateTime.now(),
        );
      },
      isPhone: false,
    );
  }

  Widget _buildTimeField(BuildContext context) {
    return CustomTextFormFeild(
      controller: timeController,
      hintText: 'Time'.tr,
      icons: const Icon(Icons.access_time),
      readOnly: true,
      onPressed: () async {
        await selectTime(context: context, timeController: timeController);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please_select_a_time'.tr;
        }
        return null;
      },
      isPhone: false,
    );
  }

  Widget _buildOperation(
      BuildContext context, LoadTransportationRoutesSuccess state) {
    return BlocBuilder<TripNavigationCubit, int>(
      builder: (context, currentPage) {
        return Column(
          children: [
            TripsNav(
              onNext: () {
                if (_isFormValid()) {
                  onValidate(UserTrips(
                    destination: destinationController.text,
                    date: dateController.text,
                    time: timeController.text,
                    price: price.value,
                    requireTicket: requireTicket,
                    currency: currency.value,
                  ));
                  trips[currentPage].copyWith(
                    destination: destinationController.text,
                    date: dateController.text,
                    time: timeController.text,
                    price: price.value,
                    requireTicket: requireTicket,
                    currency: currency.value,
                  );
                  if (currentPage == trips.length - 1) {
                    trips.add(const UserTrips());
                  }
                  context
                      .read<TripNavigationCubit>()
                      .goToNextPage(trips.length);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please_fill_out_all_fields_correctly'.tr),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              onPrevious: () {
                if (_isFormValid()) {
                  onValidate(UserTrips(
                    destination: destinationController.text,
                    date: dateController.text,
                    time: timeController.text,
                    price: price.value,
                    requireTicket: requireTicket,
                    currency: currency.value,
                  ));
                  trips[currentPage].copyWith(
                    destination: destinationController.text,
                    date: dateController.text,
                    time: timeController.text,
                    price: price.value,
                    requireTicket: requireTicket,
                    currency: currency.value,
                  );
                  context.read<TripNavigationCubit>().goToPreviousPage();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please_fill_out_all_fields_correctly'.tr),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              isNextEnabled: currentPage < trips.length - 1,
              isPreviousEnabled: currentPage > 0,
            ),
            Row(
              mainAxisAlignment: currentPage != 0
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceAround,
              children: [
                Visibility(
                  visible: trips.length > 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (trips.length > 1) {
                        if (currentPage != 0) {
                          trips.removeAt(currentPage);
                          context
                              .read<TripNavigationCubit>()
                              .goToPreviousPage();
                        } else {
                          context
                              .read<TripNavigationCubit>()
                              .goToNextPage(trips.length);
                          trips.removeAt(0);
                        }
                      }
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text("Delete Trip"),
                  ),
                ),
                SizedBox(
                  width: currentPage != 0 ? 10 : 0,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isFormValid()) {
                      onValidate(UserTrips(
                        destination: destinationController.text,
                        date: dateController.text,
                        time: timeController.text,
                        price: price.value,
                        requireTicket: requireTicket,
                        currency: currency.value,
                      ));
                      trips[currentPage].copyWith(
                        destination: destinationController.text,
                        date: dateController.text,
                        time: timeController.text,
                        price: price.value,
                        requireTicket: requireTicket,
                        currency: currency.value,
                      );
                      double totalPrice = 0;
                      bool ticket = false;
                      for (int i = 0; i < trips.length; i++) {
                        totalPrice = totalPrice + int.parse(trips[i].price!);
                        if (trips[i].requireTicket == "1") {
                          ticket = true;
                        }
                      }

                      pushReplacement(
                          context,
                          TouristProgramDetails(
                              trips: trips,
                              totalPrice: totalPrice,
                              currency: currency,
                              image: image,
                              vehicleType: vehicleType,
                              ticket: ticket));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Please_fill_out_all_fields_correctly'.tr),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                  ),
                  child: Text("continue".tr),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  bool _isFormValid() {
    logInfo(
      'validate : ${destinationController.text}\n${timeController.text}\n${dateController.text}\n$currency\n$price \n$requireTicket',
    );
    return destinationController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        currency != "empty" &&
        price != "empty" &&
        dateController.text.isNotEmpty &&
        requireTicket != "empty";
  }
}
