import 'package:bloc/bloc.dart';

class TripNavigationCubit extends Cubit<int> {
  TripNavigationCubit() : super(0);

  void updatePage(int index) {
    emit(index);
  }

  void goToNextPage(int totalTrips) {
    emit(state + 1);
  }

  void goToPreviousPage() {
    if (state > 0) {
      emit(state - 1);
    } else {
      emit(0);
    }
  }
}
