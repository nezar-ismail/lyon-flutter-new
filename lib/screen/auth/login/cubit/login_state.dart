part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError(this.errorMessage);
}

class RegisterSuccess extends LoginState {}

class RegisterError extends LoginState {
  final String errorMessage;

  RegisterError(this.errorMessage);
}

class LanguageChanged extends LoginState {
  final int language;

  LanguageChanged(this.language);
}

class CompanyModeChanged extends LoginState {
  final bool isCompany;

  CompanyModeChanged(this.isCompany);
}
