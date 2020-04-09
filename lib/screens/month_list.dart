import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/db/database.dart';
import '../services/dao/rushes_dao.dart';
import '../utils/extensions.dart';
import '../widgets/back_button.dart';
import 'day_list.dart';

class MontListPage extends StatelessWidget {
  const MontListPage({
    Key key,
    @required this.month,
  }) : super(key: key);

  final String month;

  LineChartData mainData(Map<String, List<Rush>> data) {
    final now = DateTime.now();
    double maxX =
        now.difference(DateTime(now.year, now.month)).inDays.toDouble();
    double maxY = 0;
    List<FlSpot> spots = [];
    for (int i = 1; i <= maxX + 1; i++) {
      final key = data.keys.firstWhere(
          (key) => int.parse(key.split('/')[0]) == i,
          orElse: () => null);
      if (key == null) {
        final spot = FlSpot(i.toDouble(), 0);
        spots.add(spot);
      } else {
        Duration total = Duration.zero;
        for (final rush in data[key]) {
          final duration = rush.endDate.difference(rush.startDate);
          total += duration;
        }
        if (total.inHours > maxY) maxY = total.inHours.toDouble();
        final spot = FlSpot(
          i.toDouble(),
          total.inHours.toDouble(),
        );
        spots.add(spot);
      }
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) => '${value.toInt()}',
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) => '${value.toInt()}',
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 1,
      maxX: maxX + 1,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  static const List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

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
                  const SizedBox(height: 24),
                  const BackWidget(),
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
                  AspectRatio(
                    aspectRatio: 1.70,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                          color: Color(0xff232d37)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 18.0, left: 12.0, top: 24, bottom: 12),
                        child: LineChart(mainData(dSortedRushes)),
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
