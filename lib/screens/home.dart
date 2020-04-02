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

  static const tStyle = TextStyle(
    fontSize: 64,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(1.0, 1.0),
        blurRadius: 2.0,
        color: Colors.black,
      ),
    ],
  );

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
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: Column(
          children: [
            Flexible(flex: 1, child: Container()),
            Flexible(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('HH').format(now),
                        style: tStyle,
                      ),
                      AnimatedOpacity(
                        opacity: showColon ? 1 : 0,
                        duration: const Duration(milliseconds: 100),
                        child: Text(
                          ':',
                          style: tStyle,
                        ),
                      ),
                      Text(
                        DateFormat('mm').format(now),
                        style: tStyle,
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(now),
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 1.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Center(
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'START WORKING 💪',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {},
                  color: Colors.indigo[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            Flexible(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }
}
