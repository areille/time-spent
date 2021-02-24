import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import '../utils/extensions.dart';
import '../widgets/back_button.dart';
import 'month_list.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            const BackWidget(),
            Expanded(
              child: StreamBuilder<Map<String, List<Rush>>>(
                stream: context.read<DB>().rushesDao.watchMonthlySortedRushes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.isEmpty) {
                      return const Center(child: Text('No data...'));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, i) => MonthCard(
                        month: snapshot.data.keys.elementAt(i),
                        rushes: snapshot.data.values.elementAt(i),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthCard extends StatelessWidget {
  const MonthCard({
    Key key,
    @required this.month,
    @required this.rushes,
  }) : super(key: key);

  final String month;
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MontListPage(month: month),
          ),
        ),
        child: Card(
          color: Colors.indigo[400],
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      month,
                      style: const TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  total.pretty(),
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
