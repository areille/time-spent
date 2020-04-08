import 'package:flutter/material.dart';

extension TimeOfDayExt on TimeOfDay {
  /// Returns a [DateTime] from a combination of [DateTime.now()] and [TimeOfDay].
  DateTime toDate() {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      this.hour,
      this.minute,
    );
  }
}
