import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_spent/widgets/back_button.dart';

import '../data/db/database.dart';
import '../services/dao/rushes_dao.dart';
import '../utils/delete_dialog.dart';
import '../utils/extensions.dart';

class DayListPage extends StatelessWidget {
  const DayListPage({
    Key key,
    @required this.day,
  }) : super(key: key);

  final String day;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Rush>>(
        stream: RushesDao(Provider.of<Database>(context)).watchRushesByDay(day),
        builder: (context, snapshot) {
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
                  const BackWidget(),
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
                  Icon(
                    Icons.timelapse,
                    color: Colors.amber,
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
              GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.deepOrange[300],
                ),
                onTap: () async {
                  final res = await deleteDialog(context);
                  if (res)
                    RushesDao(Provider.of<Database>(context, listen: false))
                        .deleteRush(rush.id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
