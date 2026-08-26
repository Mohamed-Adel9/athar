import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localizations != null, 'AppLocalizations was not found.');
    return localizations!;
  }

  static TextDirection textDirectionFor(Locale locale) {
    return locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }

  bool get isArabic => locale.languageCode == 'ar';

  String get appTitle => _text(ar: 'أثر', en: 'Athar');
  String get home => _text(ar: 'الرئيسية', en: 'Home');
  String get shop => _text(ar: 'المنتجات', en: 'Shop');
  String get designer => _text(ar: 'التصميم', en: 'Design');
  String get cart => _text(ar: 'السلة', en: 'Cart');
  String get profile => _text(ar: 'حسابي', en: 'Profile');
  String get settings => _text(ar: 'الإعدادات', en: 'Settings');
  String get language => _text(ar: 'اللغة', en: 'Language');
  String get arabic => _text(ar: 'العربية', en: 'Arabic');
  String get english => _text(ar: 'الإنجليزية', en: 'English');
  String get logout => _text(ar: 'تسجيل الخروج', en: 'Logout');

  String _text({required String ar, required String en}) {
    return isArabic ? ar : en;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
