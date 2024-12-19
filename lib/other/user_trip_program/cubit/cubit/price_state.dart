part of 'price_cubit.dart';

sealed class PriceState extends Equatable {
  const PriceState();

  @override
  List<Object> get props => [];
}

final class PriceInitial extends PriceState {}

final class RefreshPrice extends PriceState {
    final String price;
    final String currency;

  const RefreshPrice(this.price, this.currency);
}
