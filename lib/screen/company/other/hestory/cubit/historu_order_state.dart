part of 'historu_order_cubit.dart';

@immutable
abstract class HistoryOrdersState extends Equatable {
  const HistoryOrdersState();
  
  @override
  List<Object?> get props => [];
}

class HistoryOrdersInitial extends HistoryOrdersState {}

class HistoryOrdersLoading extends HistoryOrdersState {}

class HistoryOrdersLoaded extends HistoryOrdersState {
  final GetOrdersCompanyModel orders;

  const HistoryOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class HistoryOrdersError extends HistoryOrdersState {
  final String errorMessage;

  const HistoryOrdersError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
