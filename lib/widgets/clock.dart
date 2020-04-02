import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({
    Key key,
  }) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
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

  Timer colonTimer;
  bool showColon;
  DateTime now;

  Timer dateTimer;

  @override
  void dispose() {
    colonTimer.cancel();
    dateTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    showColon = true;
    colonTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => setState(() {
        showColon = !showColon;
      }),
    );
    now = DateTime.now();
    dateTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {
        now = DateTime.now();
      }),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
    );
  }
}
