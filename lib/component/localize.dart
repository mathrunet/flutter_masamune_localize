part of masamune.localize;

/// Class to translate.
///
/// Execute the [initialize()] method and load the csv file.
///
/// After that, display the translated text by executing the [get()] method.
class Localize {
  static const String _defaultLoacle = "en_US";
  static Map<String, Map<String, String>> _collection;
  static Map<String, String> get _document {
    if (__document == null) __document = _collection[language];
    return __document;
  }

  static Map<String, String> __document;

  /// Language settings for translation.
  static String get language {
    if (_language != null) return _language;
    _language = locale.split("_")?.first;
    __document = _collection[_language];
    return _language;
  }

  /// Language locale setting.
  static String get locale {
    if (_locale != null) return _locale;
    return _defaultLoacle;
  }

  /// Language locale setting.
  ///
  /// [locale]: Locale.
  static set locale(String locale) {
    _locale = locale;
    _language = locale.split("_")?.first;
    __document = _collection[language];
  }

  static String _locale;
  static String _language;

  /// True if initialization has been completed.
  static bool get isInitialized => _isInitialized;
  static bool _isInitialized = false;

  /// Get translated text.
  ///
  /// [key]: Key to get.
  /// [defaultValue]: Initial value.
  static String get(String key, {String defaultValue}) {
    if (_document == null || !_document.containsKey(key))
      return defaultValue ?? key;
    return _document[key] ?? defaultValue ?? key;
  }

  /// Initialize localization.
  ///
  /// [path]: Translation file path.
  /// [timeout]: Timeout time.
  /// [locale]: Default locale.
  static Future initialize(String path,
      {Duration timeout = const Duration(seconds: 5), String locale}) async {
    try {
      if (path == null || path.length <= 0) {
        debugPrint("CSV File path is empty.");
        return Future.error("CSV File path is empty.");
      }
      String csv = await rootBundle.loadString(path).timeout(timeout);
      if (csv == null || csv.length <= 0) {
        debugPrint("CSV data is empty.");
        return Future.error("CSV data is empty.");
      }
      _collection = {};
      Map<int, String> num2lang = {};
      csv = csv.replaceAll("\r\n", "\n").replaceAll("\r", "\n");
      List<List> converted = const CsvToListConverter().convert(csv, eol: "\n");
      for (int y = 1; y < converted.length; y++) {
        List line = converted[y];
        if (line == null) continue;
        for (int x = 1; x < line.length; x++) {
          String tmp = line[x];
          if (tmp == null || tmp.length <= 0) continue;
          if (y == 1) {
            List<String> langs = tmp.split(":");
            _collection[langs.first] = {};
            num2lang[x - 1] = langs.first;
          } else {
            String key = line.first;
            String tmp = line[x];
            if (tmp == null || tmp.length <= 0) continue;
            if (key == null || key.length <= 0 || key.startsWith("#")) continue;
            Map<String, String> doc = _collection[num2lang[x - 1]];
            doc[key] = tmp;
          }
        }
      }
      Locale deviceLocale = await DeviceLocale.getCurrentLocale();
      if (deviceLocale == null) return;
      if (locale == null || locale.length <= 0) {
        _locale = deviceLocale.languageCode;
        if (_locale == null || _locale.length <= 0) _locale = "en_US";
        initializeDateFormatting(_locale);
        _language = _locale.split("_")?.first;
      } else {
        _locale = locale;
        initializeDateFormatting(locale);
        _language = _locale.split("_")?.first;
      }
      __document = _collection[_language];
      _isInitialized = true;
    } catch (e) {
      print(e.toString());
      await initialize(path, timeout: timeout);
    }
  }
}
