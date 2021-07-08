import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recipe_book_flutter/src/core/localization/generated/l10n.dart';

abstract final class const Localization() {
  static const AppLocalizationDelegate _delegate = AppLocalizations.delegate;

  static List<Locale> get supportedLocales => _delegate.supportedLocales;

  static List<LocalizationsDelegate<void>> get delegates => [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    _delegate,
  ];

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context);
}

extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => Localization.of(this);
}
