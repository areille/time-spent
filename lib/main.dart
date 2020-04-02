import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'data/db/database.dart';
import 'screens/home.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(
    Provider<Database>(
      create: (_) => Database(),
      child: App(),
      dispose: (_, db) => db.close(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Spent',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}
