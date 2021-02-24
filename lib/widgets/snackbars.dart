import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void successSnackBar(BuildContext context, String label) {
  Flushbar(
    icon: const Icon(
      Icons.check_circle_outline,
      color: Colors.greenAccent,
    ),
    duration: const Duration(seconds: 3),
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: const EdgeInsets.all(24),
    borderRadius: 8,
    message: label,
    shouldIconPulse: false,
  ).show(context);
}
