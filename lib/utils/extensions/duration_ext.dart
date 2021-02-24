extension DurationExt on Duration {
  /// Returns an human readable string associated to this [Duration]
  ///
  /// ```dart
  /// assert(Duration(seconds: 2).pretty() == '2s');
  /// assert(Duration(minutes: 90).pretty() == '1 h 30 min');
  /// ```
  String pretty() {
    if (inSeconds < 60) {
      return '$inSeconds s';
    } else if (inMinutes < 60) {
      return '$inMinutes min';
    } else {
      return '$inHours h ${inMinutes.remainder(60)} min';
    }
  }
}
