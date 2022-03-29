import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'oshinstar_localization.dart';

class LocalizationMixin {
  static String _getLabel(BuildContext context, String text, labelExist) {
    String? translatedLabel =
        OshinstarLocalizations.of(context)?.getLabel(text);
    bool labelExists = translatedLabel != '' &&
        translatedLabel!.isNotEmpty &&
        translatedLabel != text;
    String _text = labelExists ? translatedLabel : text;
    return _text;
  }

  String t(BuildContext context, String text, [String? placeholder]) {
    if (OshinstarLocalizations.of(context) == null) return text;
    String? translatedLabel =
        OshinstarLocalizations.of(context)?.getLabel(text);
    bool labelExists = translatedLabel != '' &&
        translatedLabel!.isNotEmpty &&
        translatedLabel != text;
    String _text = labelExists ? translatedLabel : text;
    //if (environment.flutterEnv == FlutterEnv.dev) return _text;
    if (!labelExists) // print('mising label=> $text'.ellipsis);
    if (!labelExists &&
        placeholder != null &&
        OshinstarLocalizations.of(context)!.locale.languageCode == 'en')
      return placeholder;
    return '${labelExists ? '>' : 'x.'} $_text';
  }
}

class TranslationMixin extends LocalizationMixin {}
