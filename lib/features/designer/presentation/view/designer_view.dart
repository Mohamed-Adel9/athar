import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/designer_cubit.dart';
import '../widgets/designer_view_body.dart';

class DesignerView extends StatelessWidget {
  const DesignerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DesignerCubit(),
      child: const Scaffold(body: DesignerViewBody()),
    );
  }
}
