import 'package:athar/core/services/router.dart';
import 'package:athar/features/home/presentation/cubit/home_cubit.dart';
import 'package:athar/shared/theme/app_theme.dart';
import 'package:athar/shared/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AtharApp extends StatelessWidget {
  const AtharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (context) => HomeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Athar App',

            // Theme
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,

            // Router
            routerConfig: router,

            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
