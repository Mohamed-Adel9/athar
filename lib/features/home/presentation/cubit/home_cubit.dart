import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/bottom_nav/bottom_nav_tab.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
    : super(
        HomeState(activeCategory: 'trending', currentTab: BottomNavTab.home),
      );

  void changeCategory(String id) {
    emit(state.copyWith(activeCategory: id));
  }

  void changeTab(BottomNavTab tab) {
    emit(state.copyWith(currentTab: tab));
  }
}
