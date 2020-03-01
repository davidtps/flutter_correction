//application.dart
import 'package:flutter/material.dart';

typedef void LocaleChangeCallback(Locale locale);

class Application {
  // List of supported languages
  final List<String> supportedLanguages = ['en', 'zh'];

  // Returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  // Function to be invoked when changing the working language
  LocaleChangeCallback onLocaleChanged;

  ///
  /// Internals
  ///
  static final Application _applic = new Application._internal();

  factory Application() {
    return _applic;
  }

  Application._internal();
}

Application applic = new Application();
