import 'package:flutter/material.dart';

class AppUserPref {
  final String lang;
  final int langIndex;
  final ThemeMode theme;
  final bool isFirstTime;
  final bool notificationsEnabled;
  AppUserPref({
    required this.lang,
    required this.langIndex,
    required this.theme,
    required this.isFirstTime,
    required this.notificationsEnabled,
  });

  factory AppUserPref.standard() {
    return AppUserPref(lang: "ar", langIndex: 1, theme: ThemeMode.light, isFirstTime: true, notificationsEnabled: true);
  }

  AppUserPref copyWith({
    String? lang,
    int? langIndex,
    ThemeMode? theme,
    bool? isFirstTime,
    bool? notificationsEnabled,
    bool? vibrationEnabled,
  }) {
    return AppUserPref(
      lang: lang ?? this.lang,
      langIndex: langIndex ?? this.langIndex,
      theme: theme ?? this.theme,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  factory AppUserPref.fromJson(Map<String, dynamic> json) {
    return AppUserPref(
      lang: json['lang'] as String,
      langIndex: json['langIndex'] as int? ?? 0,
      theme: ThemeMode.values[json['theme'] as int],
      isFirstTime: json['isFirstTime'] as bool? ?? true,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lang': lang,
      'langIndex': langIndex,
      'theme': theme.index,
      'isFirstTime': isFirstTime,
      'notificationsEnabled': notificationsEnabled,
    };
  }
}
