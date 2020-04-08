import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'data/db/database.dart';
import 'screens/home.dart';
import 'services/bloc/work_bloc.dart';
import 'services/dao/rushes_dao.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(
    Provider<Database>(
      create: (context) => Database(),
      dispose: (_, db) => db.close(),
      child: BlocProvider<WorkBloc>(
        child: App(),
        create: (context) => WorkBloc(
          rushesDao: RushesDao(Provider.of<Database>(context, listen: false)),
        ),
      ),
    ),
  );
}

class App extends StatelessWidget {
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
        textTheme: TextTheme(body1: style),
      ),
      home: HomePage(),
    );
  }
}
