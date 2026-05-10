import 'package:athar/features/profile/presentation/view/profile_view.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
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
        return const Center(
          child: CustomText('Wishlist', variant: TextVariant.bodyMedium),
        );

      case BottomNavTab.designer:
        return const Center(child: Text('Designer'));

      case BottomNavTab.cart:
        return const Center(child: Text('Cart'));

      case BottomNavTab.profile:
        return ProfileScreen();
    }
  }
}
