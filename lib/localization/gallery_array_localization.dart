import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class GalleryArrayLocalization{
  final Locale locale;

  GalleryArrayLocalization(this.locale);

  static GalleryArrayLocalization of(BuildContext context){
    return Localizations.of<GalleryArrayLocalization>(context, GalleryArrayLocalization);
  }

  Map<String, String> _localizedValues;

  Future load() async {
    String jsonStringValues = await rootBundle.loadString(
        'lib/lang/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues = mappedJson.map((key, value) =>
        MapEntry(key, value.toString()));
  }
  
  String getTranslation(String key){
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<GalleryArrayLocalization> delegate = _GalleryArrayLocalizationDelegate();
}

class _GalleryArrayLocalizationDelegate extends LocalizationsDelegate<GalleryArrayLocalization>{

  const _GalleryArrayLocalizationDelegate();
  @override
  bool isSupported(Locale locale){
    return ['es','en','pt'].contains(locale.languageCode);
  }

  @override
  Future<GalleryArrayLocalization> load(Locale locale) async {
    GalleryArrayLocalization localization = new GalleryArrayLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<GalleryArrayLocalization> old) {
    return false;
  }
  
}