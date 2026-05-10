import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/custom_text.dart';
import '../cubit/profile_cubit.dart';
import '../widget/profile_view_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: CustomText('حسابي', variant: TextVariant.headingLarge),
        ),
        body: ProfileViewBody(),
      ),
    );
  }
}
