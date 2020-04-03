import 'package:flutter/material.dart';

Future<bool> deleteDialog(context) => showDialog(
      context: context,
      child: AlertDialog(
        content: Text('Delete this input ?'),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text('YES'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
