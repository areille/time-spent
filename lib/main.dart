import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'data/db/database.dart';
import 'screens/home.2.dart';
import 'services/bloc/work_bloc.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<DB>(
          create: (context) => DB(),
          dispose: (_, db) => db.close(),
        ),
        BlocProvider<WorkBloc>(
          create: (context) => WorkBloc(context: context),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Spent',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const HomePage(),
    );
  }
}
