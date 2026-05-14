import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cart_item_model.dart';
import '../../cubit/cart_cubit.dart';
import '../../cubit/cart_state.dart';
import 'cart_item_card.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartCubit, CartState, List<CartItemModel>>(
      selector: (state) => state.items,
      builder: (context, items) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, index) => CartItemCard(item: items[index]),
        );
      },
    );
  }
}
