part of masamune.localize;

/// String extension methods.
extension LocalizeStringExtension on String {
  /// Get translated text.
  String localize() => Localize.get(this, defaultValue: this);
}

/// DateTime extension methods.
extension LocalizeDateTimeExtension on DateTime {
  /// Gets the localized week.
  String get localizedWeekDay => "WeekDay${this.weekday.toString()}".localize();

  /// Gets the localized week.
  String get shortLocalizedWeekDay =>
      "Week${this.weekday.toString()}".localize();
}
