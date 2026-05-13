import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/app_color.dart';
import '../cubit/wishlist_cubit.dart';
import '../widgets/wishlist_view_body.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WishlistCubit(),
      child: const Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: SafeArea(child: WishlistViewBody()),
      ),
    );
  }
}
