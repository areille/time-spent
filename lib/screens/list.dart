import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import '../services/dao/rushes_dao.dart';
import '../utils/duration_ext.dart';
import 'month_list.dart';

class ListPage extends StatelessWidget {
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
        child: FutureBuilder<Map<String, List<Rush>>>(
          future: RushesDao(Provider.of<Database>(context)).monthlySortedRushes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                return Center(
                  child: Text('No data...'),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, i) => MonthCard(
                  month: [...snapshot.data.keys][i],
                  rushes: [...snapshot.data.values][i],
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }
}

class MonthCard extends StatelessWidget {
  final String month;
  final List<Rush> rushes;

  const MonthCard({
    Key key,
    @required this.month,
    @required this.rushes,
  }) : super(key: key);

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
                      month,
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
            builder: (_) => MontListPage(
              month: month,
              rushes: rushes,
            ),
          ),
        ),
      ),
    );
  }
}
