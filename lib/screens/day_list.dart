import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/db/database.dart';
import '../utils/duration_ext.dart';

class DayListPage extends StatelessWidget {
  const DayListPage({
    Key key,
    @required this.day,
    @required this.rushes,
  }) : super(key: key);

  final String day;
  final List<Rush> rushes;

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
          children: <Widget>[
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Card(
                color: Colors.indigo[400],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(day),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rushes.length,
                itemBuilder: (_, i) => RushCard(rush: rushes[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RushCard extends StatelessWidget {
  const RushCard({Key key, @required this.rush}) : super(key: key);

  final Rush rush;

  @override
  Widget build(BuildContext context) {
    final startPretty = DateFormat('HH:mm').format(rush.startDate);
    final endPretty = DateFormat('HH:mm').format(rush.endDate);
    final durationPretty = rush.endDate.difference(rush.startDate).pretty();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.indigo[400],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.timelapse,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'From $startPretty to $endPretty | $durationPretty',
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
