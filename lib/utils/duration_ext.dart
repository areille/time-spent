extension DurationExt on Duration {
  /// Returns an human readable string associated to this [Duration]
  ///
  /// ```dart
  /// assert(Duration(seconds: 2).pretty() == '2s');
  /// assert(Duration(minutes: 90).pretty() == '1 h 30 min');
  /// ```
  String pretty() {
    if (this.inSeconds < 60)
      return '${this.inSeconds} s';
    else if (this.inMinutes < 60)
      return '${this.inMinutes} min';
    else
      return '${this.inHours} h ${this.inMinutes.remainder(60)} min';
  }
}
