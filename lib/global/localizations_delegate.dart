import 'package:flutter/widgets.dart';

import 'oshinstar_localization.dart';


class OshinLocalizationsDelegate
    extends LocalizationsDelegate<OshinstarLocalizations> {
  String? version;
  Map<String, String>? json;

  OshinLocalizationsDelegate({this.version, this.json});

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<OshinstarLocalizations> load(Locale locale) async {
    return OshinstarLocalizations(locale, json!);
  }

  @override
  bool shouldReload(OshinLocalizationsDelegate old) => true;
}
