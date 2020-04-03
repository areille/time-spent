import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_spent/services/dao/rushes_dao.dart';

import '../data/db/database.dart';
import '../utils/duration_ext.dart';
import 'day_list.dart';

class MontListPage extends StatelessWidget {
  const MontListPage({
    Key key,
    @required this.month,
  }) : super(key: key);

  final String month;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Rush>>(
        stream:
            RushesDao(Provider.of<Database>(context)).watchRushesByMonth(month),
        builder: (context, snapshot) {
          final Map<String, List<Rush>> dSortedRushes = {};
          if (snapshot.hasData && snapshot.data.isNotEmpty)
            for (final rush in snapshot.data) {
              final day = DateFormat('dd/MM').format(rush.startDate);
              if (dSortedRushes.containsKey(day))
                dSortedRushes[day].add(rush);
              else
                dSortedRushes.addAll({
                  day: [rush]
                });
            }
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
                        child: Text(month),
                      ),
                    ),
                  ),
                  if (snapshot.hasData && snapshot.data.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: dSortedRushes.length,
                        itemBuilder: (_, i) => DayCard(
                          day: [...dSortedRushes.keys][i],
                          rushes: [...dSortedRushes.values][i],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }
}

class DayCard extends StatelessWidget {
  const DayCard({
    Key key,
    @required this.day,
    @required this.rushes,
  }) : super(key: key);

  final String day;
  final List<Rush> rushes;

  @override
  Widget build(BuildContext context) {
    Duration total = Duration.zero;
    for (final rush in rushes) {
      final duration = rush.endDate.difference(rush.startDate);
      total += duration;
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        child: Card(
          color: Colors.indigo[400],
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      day,
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  total.pretty(),
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DayListPage(day: day),
          ),
        ),
      ),
    );
  }
}
