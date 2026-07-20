import 'package:flutter/material.dart';

class AppLanguageModel {
  final String languageCode;
  final String langTitle;

  AppLanguageModel({required this.languageCode, required this.langTitle});
}

List<AppLanguageModel> appLanguages(BuildContext context) {
  return [
    AppLanguageModel(languageCode: 'en', langTitle: "english"),
    AppLanguageModel(languageCode: 'ar', langTitle: "arabic"),
  ];
}
