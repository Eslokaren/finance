class Lang {
  String? locale;
  Map<String, String>? labels;

  Lang({this.locale, this.labels});

  static Lang fromJson(Map data, String locale) {
    Map<String, String> labels = {};

    data.entries.forEach((e) {
      labels.addAll({e.key.toString(): e.value.toString()});
    });

    return Lang(labels: labels, locale: locale);
  }
}
