import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/fetch_home_usecase.dart';
import '../widgets/bottom_nav/bottom_nav_tab.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._fetchHomeUseCase) : super(HomeState.initial()) {
    fetchHome();
  }

  final FetchHomeUseCase _fetchHomeUseCase;

  Future<void> fetchHome() async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));

    final result = await _fetchHomeUseCase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            data: data,
            activeCategory: 'all',
            clearError: true,
          ),
        );
      },
    );
  }

  void changeCategory(String id) {
    emit(state.copyWith(activeCategory: id));
  }

  void search(String value) {
    emit(state.copyWith(searchQuery: value));
  }

  void addReview({
    required String name,
    required String text,
    required int rating,
  }) {
    final review = HomeReviewEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      displayName: name.trim(),
      displayText: text.trim(),
      rating: rating,
    );

    emit(
      state.copyWith(
        data: state.data.copyWith(reviews: [review, ...state.data.reviews]),
      ),
    );
  }

  void changeTab(BottomNavTab tab) {
    emit(state.copyWith(currentTab: tab));
  }
}
