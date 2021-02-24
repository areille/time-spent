import 'package:flutter/material.dart';

Future<bool> deleteDialog(BuildContext context) => showDialog<bool>(
      context: context,
      child: AlertDialog(
        content: const Text('Delete this input ?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('YES'),
          ),
        ],
      ),
    );
