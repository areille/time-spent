extension DateTimeExt on DateTime {
  /// Returns a string representation of time elapsed from [DateTime] to now.
  ///
  /// ```dart
  /// assert(yesterday.timeAgo == '1 day ago')
  /// assert(lastYear.timeAgo == '1 year ago')
  /// ```
  String timeAgo() {
    final diff = DateTime.now().difference(this).inMilliseconds;
    final num seconds = diff / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    String result;
    if (seconds < 45)
      result = 'less than one minute ago';
    else if (seconds < 90)
      result = 'one minute ago';
    else if (minutes < 45)
      result = '${minutes.round()}min ago';
    else if (minutes < 90)
      result = 'one hour ago';
    else if (hours < 24)
      result = '${hours.round()}h ago';
    else if (hours < 48)
      result = 'one day ago';
    else if (days < 30)
      result = '${days.round()} days ago';
    else if (days < 60)
      result = 'one month ago';
    else if (days < 365)
      result = '${months.round()} months ago';
    else if (years < 2)
      result = 'one year ago';
    else
      result = '${years.round()} years ago';
    return result;
  }
}
