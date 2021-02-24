import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'data/db/database.dart';
import 'screens/home.dart';
import 'services/bloc/work_bloc.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(
    Provider<DB>(
      create: (context) => DB(),
      dispose: (_, db) => db.close(),
      child: BlocProvider<WorkBloc>(
        create: (context) => WorkBloc(context: context),
        child: const App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  static const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    fontStyle: FontStyle.italic,
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Spent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(bodyText2: style),
      ),
      home: const HomePage(),
    );
  }
}
