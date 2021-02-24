import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import '../utils/delete_dialog.dart';
import '../utils/extensions.dart';
import '../widgets/back_button.dart';

class DayListPage extends StatelessWidget {
  const DayListPage({
    Key key,
    @required this.day,
  }) : super(key: key);

  final String day;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Rush>>(
        stream: context.read<DB>().rushesDao.watchRushesByDay(day),
        builder: (context, snapshot) {
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Card(
                      color: Colors.indigo[400],
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(day),
                      ),
                    ),
                  ),
                  if (snapshot.hasData && snapshot.data.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, i) => RushCard(rush: snapshot.data[i]),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.timelapse,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'From $startPretty to $endPretty | $durationPretty',
                    style: const TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  final res = await deleteDialog(context);
                  if (res) {
                    await context.read<DB>().rushesDao.deleteRush(rush.id);
                  }
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.deepOrange[300],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
