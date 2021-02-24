import 'package:flutter/material.dart';

Future<bool> confirmationDialog(
  BuildContext context,
  String label,
  String confirmLabel,
) =>
    showDialog<bool>(
      context: context,
      child: AlertDialog(
        title: const Text('Warning'),
        content: Text(label),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
