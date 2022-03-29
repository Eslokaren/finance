import 'package:flutter/widgets.dart';

class OshinstarLocalizations {
  final Locale locale;
  final Map<String, String> labels;

  OshinstarLocalizations(this.locale, this.labels);

  static OshinstarLocalizations? of(BuildContext context) {
    return Localizations.of<OshinstarLocalizations>(
        context, OshinstarLocalizations);
  }

  String getLabel(String key) {
    if (!labels.containsKey(key) || labels[key]!.isEmpty) return key;
    return labels[key]!;
  }
}