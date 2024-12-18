part of 'trip_form_cubit.dart';

@immutable
sealed class TripFormState {}

final class TripFormInitial extends TripFormState {}

final class TripFormLoading extends TripFormState {}

final class GoToNextItem extends TripFormState {}

final class GoToPreviousItem extends TripFormState {}

final class TripFormAddItem extends TripFormState {}

final class TripFormDeleteItem extends TripFormState {}

final class TripFormSubmit extends TripFormState {}

final class GetTripsDestinationSuccess extends TripFormState {
  final List<String> destinationList;

  GetTripsDestinationSuccess({required this.destinationList});
}

final class GetTripsDestinationFailure extends TripFormState {
  final String message;
  GetTripsDestinationFailure({required this.message});
}

final class GetTripsPriceSuccess extends TripFormState {
  final String price;
  final String currency;
  GetTripsPriceSuccess({required this.price, required this.currency});
}

final class GetTripsPriceFailure extends TripFormState {
  final String message;
  GetTripsPriceFailure({required this.message});
}

final class GetTripsPriceLoading extends TripFormState {}

final class GoToProgram extends TripFormState {}
