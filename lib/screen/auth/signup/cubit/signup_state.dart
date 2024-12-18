import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupError extends SignupState {
  final String message;

  SignupError(this.message);

  @override
  List<Object?> get props => [message];
}

class DuplicateCheckInProgress extends SignupState {}

class DuplicateCheckFailed extends SignupState {
  final String error;

  DuplicateCheckFailed(this.error);

  @override
  List<Object?> get props => [error];
}
