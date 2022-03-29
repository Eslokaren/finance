import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class Translation {
  /**
   * /// [loadLanguage] esta funcion se llama en el initState() de LoginScreen() 
   * 
   * Carga los keys, y los guarda en Hive (donde se llame)
   */
  Future loadLanguage(String locale) async {
    final Map body = {"locale": locale};

    final response = await http.post(
        Uri.parse("https://services.oshinstar.net/weblate/keys2"),
        body: body);
    return json.decode(response.body);
    // print(json.decode(response.body)['discover.discover_connections.video_tab.item_subtitle.location.global']);
  }

  String t(dynamic context, String key, [dynamic style]) {
    return context.get('keys')[key].toString();
  }

  // Widget t(dynamic context, String key, [dynamic style]) {
  //   final parsedKey = parseKey(context, key, style).toString();
  //   return Text(parsedKey);
  // }
}

//tiene que ser algo de eso await
