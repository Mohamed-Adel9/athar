import 'package:athar/features/wishlist/presentation/widgets/wishlist_cart_item.dart';
import 'package:athar/shared/theme/app_spacing.dart';
import 'package:athar/shared/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_states.dart';

class WishlistViewBody extends StatelessWidget {
  const WishlistViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            'المفضله',
                            variant: TextVariant.headingMedium,
                          ),

                          const SizedBox(height: 6),
                          CustomText(
                            '${state.items.length} عناصر محفوظه ',
                            variant: TextVariant.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.favorite, color: Colors.red, size: 32),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: .75,
                ),
                delegate: SliverChildBuilderDelegate(
                  childCount: state.items.length,
                  (context, index) {
                    final item = state.items[index];

                    return WishlistItemCard(
                      item: item,
                      onRemove: () {
                        context.read<WishlistCubit>().removeItem(item.id);
                      },
                      onCart: () {
                        context.read<WishlistCubit>().addToCart(item);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
