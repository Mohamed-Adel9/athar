import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/app_color.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_view_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: AuthViewBody(
          onLogin: () {
            context.go('/home');
          },
          onRegister: () {
            context.go('/home');
          },
        ),
      ),
    );
  }
}
