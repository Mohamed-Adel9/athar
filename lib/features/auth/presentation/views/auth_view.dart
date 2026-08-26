import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/snack_bar_service.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_states.dart';
import '../widgets/auth_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          context.go('/home');
        }

        if (state.status == AuthStatus.failure && state.errorMessage != null) {
          SnackBarService.failure(
            context: context,
            message: state.errorMessage!,
          );
        }
      },
      child: const Scaffold(
        body: AuthForm(),
      ),
    );
  }
}
