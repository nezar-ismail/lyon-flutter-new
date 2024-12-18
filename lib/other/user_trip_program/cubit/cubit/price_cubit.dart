import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'price_state.dart';

class PriceCubit extends Cubit<PriceState> {
  PriceCubit() : super(PriceInitial());

  void refreshPrice(String price, String currency) {
    emit(RefreshPrice(price, currency));
  }
}
