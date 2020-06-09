part of masamune.localize;

/// String extension methods.
extension LocalizeStringExtension on String {
  /// Get translated text.
  String localize() => Localize.get(this, defaultValue: this);
}
