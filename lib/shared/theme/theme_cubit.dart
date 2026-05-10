import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  Future<void> toggleTheme() async {
    final isDark = state == ThemeMode.dark;

    emit(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
