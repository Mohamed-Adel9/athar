import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart/cart_app_bar.dart';
import '../widgets/cart/cart_items_list.dart';
import '../widgets/cart/cart_summary.dart';
import '../widgets/cart/empty_cart.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: SafeArea(
            child: state.items.isEmpty
                ? const EmptyCart()
                : const CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: CartAppBar()),
                      SliverToBoxAdapter(child: SizedBox(height: 16)),
                      SliverToBoxAdapter(child: CartItemsList()),
                      SliverToBoxAdapter(child: SizedBox(height: 24)),
                      SliverToBoxAdapter(child: CartSummary()),
                      SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
