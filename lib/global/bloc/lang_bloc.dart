// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:oshinstar_app/helpers_____/languages.dart';
// import 'package:oshinstar_app/helpers_____/local_storage.dart';
// import 'package:oshinstar_app/modules/global/blocs/lang/lang_state.dart';
// import 'package:oshinstar_app/modules/languages/models/lang.dart';
// import 'package:oshinstar_app/services_____/api/api.dart';
// import 'dart:math';

// class LangBloc extends Cubit<LangState> {
//   LangBloc() : super(LangState(loading: false));

//   _getAndSaveLanguage(String locale, {String version}) async {
//     var response = await api.lang.getAppLangLabels(
//         lang: locale, fallBackLang: locale, cacheKey: version);
//    var lang = Lang.fromJson(response.data, locale);
//     localStorage.setItem(locale, lang.labels);
//     return lang.labels;
//   }

//   Future<void> _loadNewVersion(langVersionKey, storedVersion, locale,
//       {bool forceRefresh}) async {
//     ApiResponse<int> response = await api.lang.getAppLangLastVersion();
//     var version = response.data.toString();
//     localStorage.setItem(langVersionKey, version);
//     if (version != storedVersion || forceRefresh == true) {
//       var labels = await _getAndSaveLanguage(locale, version: version);
//       emit(state.copyWith(
//           locale: locale, labels: labels, version: version, loading: false));
//     }
//   }

//   Future<void> loadLanguage(BuildContext context, {String locale}) async {
//     if (state.loading == true) return;

//     emit(state.copyWith(loading: true));

//     locale = locale ??
//         localStorage.getItem('user-locale') ??
//         Localizations.localeOf(context).languageCode;

//     locale = supportedLanguages
//         .firstWhere((e) => e.code == locale,
//             orElse: () => supportedLanguages[0])
//         .code;

//     localStorage.setItem('user-locale', locale);

//     var storedLang = localStorage.getItem(locale);
//     var langVersionKey = '$locale-Version';
//     var storedVersion = localStorage.getItem(langVersionKey);

//     if (storedLang == null) {
//       await _loadNewVersion(langVersionKey, storedVersion, locale,
//           forceRefresh: true);
//     } else {
//       //dont wait for the language to load if lang is already on the storage
//       _loadNewVersion(langVersionKey, storedVersion, locale);
//     }

//     if (storedLang != null) {
//       var lang = Lang.fromJson(storedLang, locale);
//       emit(
//         state.copyWith(
//           locale: locale,
//           labels: lang.labels,
//           version: storedVersion,
//         ),
//       );
//     }
//     emit(state.copyWith(loading: false));
//   }
// }
