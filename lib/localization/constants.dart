import 'package:flutter/material.dart';
import 'package:gallery_array/localization/gallery_array_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTransValue(BuildContext context, String key){
  return GalleryArrayLocalization.of(context).getTranslation(key);
}

//LANG CONSTANTS
const String SPANISH = 'es';
const String ENGLISH = 'en';
const String PORTUGUESE = 'pt';

const String LANGUAGE_CODE = 'languageCode';

Future<Locale> setLocale(String languageCode) async{
  SharedPreferences _preferences = await SharedPreferences.getInstance();

  await _preferences.setString(LANGUAGE_CODE, languageCode);

  return _locale(languageCode);

}

Locale _locale(String languageCode){
  Locale _temp;
  switch(languageCode){
    case SPANISH:
      _temp = Locale(languageCode, 'MX');
      break;
    case ENGLISH:
      _temp = Locale(languageCode, 'US');
      break;
    case PORTUGUESE:
      _temp = Locale(languageCode, 'PT');
      break;
    default:
      _temp = Locale(SPANISH, 'MX');
  }
  return _temp;
}

Future<Locale> getLocale() async{
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  String languageCode = _preferences.getString(LANGUAGE_CODE) ?? 'es';
  return _locale(languageCode);

}