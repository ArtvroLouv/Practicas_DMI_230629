import 'package:flutter/material.dart';

enum AppCountry {
  usa(
    flag: '🇺🇸',
    displayName: 'United States',
    languageName: 'English',
    languageCode: 'en',
    regionCode: 'US',
  ),
  mexico(
    flag: '🇲🇽',
    displayName: 'México',
    languageName: 'Español',
    languageCode: 'es',
    regionCode: 'MX',
  ),
  germany(
    flag: '🇩🇪',
    displayName: 'Deutschland',
    languageName: 'Deutsch',
    languageCode: 'de',
    regionCode: 'DE',
  );

  const AppCountry({
    required this.flag,
    required this.displayName,
    required this.languageName,
    required this.languageCode,
    required this.regionCode,
  });

  final String flag;
  final String displayName;
  final String languageName;
  final String languageCode;
  final String regionCode;

  String get selectionLabel => '$flag $displayName ($languageName)';
  Locale get locale => Locale(languageCode, regionCode);
}
