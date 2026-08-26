import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_states.dart';
import '../cubit/profile_cubit.dart';
import '../widget/profile_view_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()
        ..fetchProfile(
          wishlistCount: context.read<WishlistCubit>().state.items.length,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            context.l10n.profile,
            variant: TextVariant.headingLarge,
          ),
        ),
        body: BlocListener<WishlistCubit, WishlistState>(
          listener: (context, state) {
            context.read<ProfileCubit>().updateWishlistCount(
              state.items.length,
            );
          },
          child: ProfileViewBody(),
        ),
      ),
    );
  }
}
