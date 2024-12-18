import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lyon/model/company_model/trips_model.dart';
import 'package:lyon/screen/company/trip_company/details_multi_trip_company.dart';
import 'package:lyon/v_done/trip_form/cubit/nav_cubit.dart';
import 'package:lyon/v_done/trip_form/cubit/trip_form_cubit.dart';
import 'package:lyon/v_done/trip_form/utils/picked_func.dart';
import 'package:lyon/v_done/trip_form/widgets/custom_drop_down.dart';
import 'package:lyon/v_done/trip_form/widgets/text_feild_form.dart';
import 'package:lyon/v_done/trip_form/widgets/trips_nav.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/v_done/utils/custom_log.dart';

// ignore: must_be_immutable
class TripForm extends StatelessWidget {
  TripForm({
    super.key,
    required this.onValidate,
    required this.vehicleType,
    required this.trip,
    required this.trips,
    required this.projectName,
  });

  final Function(ListElement trip) onValidate;
  String price = 'empty';
  String currency = 'empty';
  ListElement trip;
  List<ListElement> trips;
  final String vehicleType;
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController tripTypeController = TextEditingController();
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerNumberController =
      TextEditingController();
  final TextEditingController customerNoteController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController projectName;

  @override
  Widget build(BuildContext context) {
    logInfo(trip.toJson().toString());
    destinationController.text = trip.destination ?? '';
    tripTypeController.text = trip.location ?? '';
    customerNameController.text = trip.customerName ?? '';
    customerNumberController.text = trip.phoneNumber ?? '';
    customerNoteController.text = trip.note ?? '';
    timeController.text = trip.time ?? '';
    dateController.text = trip.date ?? '';
    price = trip.price.toString();
    currency = trip.currency.toString();

    return BlocProvider(
      lazy: false,
      create: (context) => TripProgramCubit()..getTripsDestination(),
      child: Builder(builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              _price(),
              _buildDestinationDropdown(context),
              _buildTripTypeDropdown(context),
              _buildDateField(context),
              _buildTimeField(context),
              _buildCustomerNameField(),
              _buildCustomerNumberField(),
              _buildCustomerNoteField(),
              _buildOperation(context),
            ],
          ),
        );
      }),
    );
  }

  Row _price() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<TripProgramCubit, TripFormState>(
          builder: (context, state) {
            if (state is GetTripsPriceSuccess) {
              price = state.price.toString();
              currency = state.currency;
              return Text(
                '${'price'.tr} : ${state.price} ${state.currency}',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 22),
              );
            } else if (state is GetTripsPriceLoading) {
              return const CircularProgressIndicator();
            }
            return price != 'empty' && price.isNotEmpty && price != 'null'
                ? Text(
                    '${'price'.tr} : $price $currency',
                    style:
                        const TextStyle(color: Colors.blueAccent, fontSize: 22),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildDestinationDropdown(BuildContext context) {
    return CustomDropDown(
      controller: destinationController,
      hintTxt:
          destinationController.text.isEmpty || destinationController.text == ''
              ? "  ${"Select_Destination".tr}"
              : "  ${destinationController.text}",
      items: context.read<TripProgramCubit>().destinationList,
      onSaved: (val) {
        destinationController.text = val.toString();
      },
      onChanged: (val) async {
        destinationController.text = val.toString();
        if (tripTypeController.text.isNotEmpty) {
          await context.read<TripProgramCubit>().getTripPrice(
              vehicleType, tripTypeController.text, destinationController.text);
        }
      },
    );
  }

  Widget _buildTripTypeDropdown(BuildContext context) {
    return CustomDropDown(
      controller: tripTypeController,
      items: const ['One Way', 'One Location', 'Multi Location'],
      hintTxt: tripTypeController.text.isEmpty || tripTypeController.text == ''
          ? "  ${'Select_Trip_Type'.tr}"
          : "   ${tripTypeController.text}",
      onSaved: (val) {
        tripTypeController.text == val.toString();
      },
      onChanged: (val) async {
        tripTypeController.text = val.toString();

        if (destinationController.text.isNotEmpty) {
          await context.read<TripProgramCubit>().getTripPrice(
              vehicleType, tripTypeController.text, destinationController.text);
        }
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

  Widget _buildCustomerNameField() {
    return CustomTextFormFeild(
      controller: customerNameController,
      hintText: 'Customer_Name'.tr,
      icons: const Icon(Icons.person),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please_enter_a_customer_name'.tr;
        }
        return null;
      },
      isPhone: false,
    );
  }

  Widget _buildCustomerNumberField() {
    return CustomTextFormFeild(
      controller: customerNumberController,
      hintText: '07xxxxxxxx',
      icons: const Icon(Icons.phone),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please_enter_a_customer_number'.tr;
        }
        return null;
      },
      isPhone: true,
    );
  }

  Widget _buildCustomerNoteField() {
    return CustomTextFormFeild(
      controller: customerNoteController,
      hintText: 'Customer_Note'.tr,
      icons: const Icon(Icons.note),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please_enter_a_customer_note'.tr;
        }
        return null;
      },
      isPhone: false,
    );
  }

  Widget _buildOperation(BuildContext context) {
    return BlocBuilder<TripNavigationCubit, int>(
      builder: (context, currentPage) {
        return Column(
          children: [
            TripsNav(
              onNext: () {
                if (_isFormValid()) {
                  onValidate(ListElement(
                    destination: destinationController.text,
                    location: tripTypeController.text,
                    customerName: customerNameController.text,
                    phoneNumber: customerNumberController.text,
                    note: customerNoteController.text,
                    date: dateController.text,
                    time: timeController.text,
                    price: double.parse(price),
                    currency: currency,
                  ));

                  trips[currentPage].copyWith(
                    destination: destinationController.text,
                    location: tripTypeController.text,
                    customerName: customerNameController.text,
                    phoneNumber: customerNumberController.text,
                    note: customerNoteController.text,
                    date: dateController.text,
                    time: timeController.text,
                    price: double.parse(price),
                    currency: currency,
                  );
                  if (currentPage == trips.length - 1) {
                    trips.add(ListElement());
                  }
                  context
                      .read<TripNavigationCubit>()
                      .goToNextPage(trips.length);
                } else {
                  if (customerNumberController.text.length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Phone_number_must_be_10_digits'.tr),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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
                  onValidate(
                    ListElement(
                      destination: destinationController.text,
                      location: tripTypeController.text,
                      customerName: customerNameController.text,
                      phoneNumber: customerNumberController.text,
                      note: customerNoteController.text,
                      date: dateController.text,
                      time: timeController.text,
                      price: double.parse(price),
                      currency: currency,
                    ),
                  );
                  trips[currentPage].copyWith(
                    destination: destinationController.text,
                    location: tripTypeController.text,
                    customerName: customerNameController.text,
                    phoneNumber: customerNumberController.text,
                    note: customerNoteController.text,
                    date: dateController.text,
                    time: timeController.text,
                    price: double.parse(price),
                    currency: currency,
                  );
                  context.read<TripNavigationCubit>().goToPreviousPage();
                } else {
                  if (customerNumberController.text.length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Phone_number_must_be_10_digits'.tr),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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
                  visible: currentPage != 0,
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
                      onValidate(ListElement(
                        destination: destinationController.text,
                        location: tripTypeController.text,
                        customerName: customerNameController.text,
                        phoneNumber: customerNumberController.text,
                        note: customerNoteController.text,
                        date: dateController.text,
                        time: timeController.text,
                        price: double.parse(price),
                        currency: currency,
                      ));
                      trips[currentPage].copyWith(
                        destination: destinationController.text,
                        location: tripTypeController.text,
                        customerName: customerNameController.text,
                        phoneNumber: customerNumberController.text,
                        note: customerNoteController.text,
                        date: dateController.text,
                        time: timeController.text,
                        price: double.parse(price),
                        currency: currency,
                      );
                      double totalPrice = 0;
                      for (int i = 0; i < trips.length; i++) {
                        totalPrice = totalPrice + trips[i].price!;
                      }
                      Trips tripProgram = Trips(
                          list: trips,
                          phone: trips[0].phoneNumber!,
                          startTime: trips[0].time!,
                          startDate: trips[0].date!,
                          name: trips[0].customerName!,
                          vechileType: vehicleType,
                          token: '',
                          mobile: 1,
                          totalPrice: totalPrice,
                          projectName: projectName.text);
                      pushReplacement(
                          context,
                          DetailsMultiTripCompany(
                            mapMobile: tripProgram,
                            totalPrice: totalPrice,
                            vechileType: vehicleType,
                            projectName: projectName.text,
                            name: '',
                            phone: '',
                          ));
                    } else {
                      if (customerNumberController.text.length < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Phone_number_must_be_10_digits'.tr),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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
      '${destinationController.text}\n${tripTypeController.text}\n${customerNameController.text}\n${customerNumberController.text}\n${customerNoteController.text}\n${timeController.text}\n${dateController.text}',
    );
    return destinationController.text.isNotEmpty &&
        tripTypeController.text.isNotEmpty &&
        customerNameController.text.isNotEmpty &&
        customerNumberController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        customerNumberController.text.length == 10 &&
        currency != "empty" &&
        price != "empty" &&
        dateController.text.isNotEmpty;
  }
}
