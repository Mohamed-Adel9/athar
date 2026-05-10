import '../widgets/bottom_nav/bottom_nav_tab.dart';

class HomeState {
  final String activeCategory;
  final BottomNavTab currentTab;

  HomeState({required this.activeCategory, required this.currentTab});

  HomeState copyWith({String? activeCategory, BottomNavTab? currentTab}) {
    return HomeState(
      activeCategory: activeCategory ?? this.activeCategory,
      currentTab: currentTab ?? this.currentTab,
    );
  }
}
