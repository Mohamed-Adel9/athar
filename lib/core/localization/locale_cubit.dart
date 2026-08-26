import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar'));

  void setLocale(Locale locale) {
    if (state.languageCode == locale.languageCode) return;
    emit(locale);
  }

  void toggleLocale() {
    emit(state.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));
  }
}
