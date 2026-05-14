import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_color.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/view/cart_view.dart';
import '../../../designer/presentation/view/designer_view.dart';
import '../../../profile/presentation/view/profile_view.dart';
import '../../../wishlist/presentation/view/wishlist_view.dart';
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
          backgroundColor: AppColors.darkBackground,
          body: _buildScreen(state.currentTab),
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

  Widget _buildScreen(BottomNavTab tab) {
    switch (tab) {
      case BottomNavTab.home:
        return HomeViewBody(onNavigate: (_) {});

      case BottomNavTab.wishlist:
        return const WishlistView();

      case BottomNavTab.designer:
        return const DesignerView();

      case BottomNavTab.cart:
        return BlocProvider(
          create: (_) => CartCubit(),
          child: const CartView(),
        );

      case BottomNavTab.profile:
        return const ProfileScreen();
    }
  }
}