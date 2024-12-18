part of 'tourist_program_cubit.dart';

@immutable
sealed class TouristProgramState {}

final class TouristProgramInitial extends TouristProgramState {}

final class LoadTransportationRoutesLoading extends TouristProgramState {}

final class LoadTransportationRoutesSuccess extends TouristProgramState {
  final List<Map<String, dynamic>> location;
  final List<String> items;
  LoadTransportationRoutesSuccess(this.location, this.items);

}
