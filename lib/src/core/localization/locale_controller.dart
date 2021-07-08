import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController._(
  final SharedPreferences _preferences,
  var Locale _locale,
) extends ChangeNotifier {
  static const _localeKey = 'app_locale';
  static const english = Locale('en');
  static const russian = Locale('ru');

  static Future<LocaleController> create() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? languageCode = preferences.getString(_localeKey);
    return LocaleController._(
      preferences,
      languageCode == english.languageCode ? english : russian,
    );
  }

  Locale get locale => _locale;

  Future<void> toggle() async {
    final Locale previousLocale = _locale;
    try {
      _locale = _locale == english ? russian : english;
      await _preferences.setString(_localeKey, _locale.languageCode);
      notifyListeners();
    } on Object {
      _locale = previousLocale;
      rethrow;
    }
  }
}
