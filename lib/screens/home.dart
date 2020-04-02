import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now;
  bool showColon;

  @override
  void initState() {
    now = DateTime.now();
    Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {
        now = DateTime.now();
      }),
    );
    showColon = true;
    Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() {
        showColon = !showColon;
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.red],
          ),
        ),
        child: Column(
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('HH${showColon ? ':' : ' '}mm').format(now)),
                  Text(DateFormat("dd/MM/yyyy").format(now)),
                ],
              ),
            ),
            Flexible(
              child: Center(
                child: RaisedButton(
                  child: Text('BEGIN WORK'),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
