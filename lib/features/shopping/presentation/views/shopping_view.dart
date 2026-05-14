import 'package:athar/features/shopping/presentation/cubit/shopping_cubit.dart';
import 'package:athar/features/shopping/presentation/widgets/shopping_product_grid.dart';
import 'package:athar/features/shopping/presentation/widgets/shpooing_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../cubit/shopping_state.dart';
import '../widgets/product_details_sheet.dart';
import '../widgets/shopping_filter_bar.dart';

class ShoppingView extends StatelessWidget {
  const ShoppingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShoppingCubit(),
      child: const _ShopViewBody(),
    );
  }
}

class _ShopViewBody extends StatelessWidget {
  const _ShopViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: BlocConsumer<ShoppingCubit, ShoppingState>(
          listenWhen: (prev, curr) =>
              prev.selectedProduct != curr.selectedProduct &&
              curr.selectedProduct != null,
          listener: (context, state) {
            if (state.selectedProduct != null) {
              _showProductDetails(context);
            }
          },
          builder: (context, state) {
            return const CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: ShoppingAppBar()),
                SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(child: ShoppingFilterBar()),
                SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(child: ShoppingProductGrid()),
                SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ShoppingCubit>(),
        child: const ProductDetailsSheet(),
      ),
    );
  }
}
