import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../cubit/designer_cubit.dart';
import '../widgets/designer_view_body.dart';

class DesignerView extends StatelessWidget {
  const DesignerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DesignerCubit>(),
      child: const Scaffold(body: DesignerViewBody()),
    );
  }
}
