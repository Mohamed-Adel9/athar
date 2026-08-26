import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/presentation/view/cart_view.dart';
import '../../../designer/presentation/view/designer_view.dart';
import '../../../profile/presentation/view/profile_view.dart';
import '../../../shopping/presentation/views/shopping_view.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import '../widgets/bottom_nav/bottom_nav.dart';
import '../widgets/bottom_nav/bottom_nav_tab.dart';
import '../widgets/home_view_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildScreen(context, state.currentTab),
          bottomNavigationBar: BottomNav(
            activeTab: state.currentTab,
            onNavigate: (tab) {
              context.read<HomeCubit>().changeTab(tab);
            },
          ),
        );
      },
    );
  }

  Widget _buildScreen(BuildContext context, BottomNavTab tab) {
    switch (tab) {
      case BottomNavTab.home:
        return HomeViewBody(
          onNavigate: (tab) {
            context.read<HomeCubit>().changeTab(tab);
          },
        );

      case BottomNavTab.shop:
        return const ShoppingView();

      case BottomNavTab.designer:
        return const DesignerView();

      case BottomNavTab.cart:
        return const CartView();

      case BottomNavTab.profile:
        return const ProfileScreen();
    }
  }
}
