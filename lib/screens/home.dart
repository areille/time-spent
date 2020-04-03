import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/db/database.dart';
import '../services/bloc/work_bloc.dart';
import '../utils/datetime_ext.dart';
import '../utils/delete_dialog.dart';
import '../utils/duration_ext.dart';
import '../widgets/clock.dart';
import 'list.dart';

const kAnimationDuration = const Duration(milliseconds: 400);
const textStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 24,
  fontStyle: FontStyle.italic,
  color: Colors.white,
);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: BlocBuilder<WorkBloc, WorkState>(
          builder: (context, state) {
            final thirdHeight = MediaQuery.of(context).size.height / 3;
            return Stack(
              children: [
                Positioned(
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ListPage()));
                    },
                    child: const Icon(Icons.list),
                    shape: const CircleBorder(),
                    fillColor: Colors.white,
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  top: 28,
                  left: 4,
                ),
                Positioned(
                  child: RawMaterialButton(
                    onPressed: () {},
                    child: const Icon(Icons.settings),
                    shape: const CircleBorder(),
                    fillColor: Colors.white,
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  top: 28,
                  right: 4,
                ),
                Column(
                  children: [
                    SizedBox(height: 24),
                    AnimatedContainer(
                      duration: kAnimationDuration,
                      curve: Curves.easeInOut,
                      height: state is Ready
                          ? MediaQuery.of(context).size.height / 2
                          : thirdHeight,
                      child: ClockWidget(),
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: kAnimationDuration,
                        child: state is InProgress
                            ? WIPWidget(startTime: state.startTime)
                            : state is Done
                                ? DoneWidget(rush: state.rush)
                                : Container(),
                      ),
                    ),
                    Container(
                      height: thirdHeight,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: kAnimationDuration,
                          child: state is Done
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RawMaterialButton(
                                      onPressed: () {
                                        BlocProvider.of<WorkBloc>(context)
                                            .add(Reset());
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green[300],
                                                ),
                                                SizedBox(width: 16),
                                                Text('Input saved !'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      shape: const CircleBorder(),
                                      fillColor: Colors.white,
                                      constraints: const BoxConstraints(
                                          minWidth: 48, minHeight: 48),
                                    ),
                                    SizedBox(width: 16),
                                    RawMaterialButton(
                                      onPressed: () async {
                                        final res = await deleteDialog(context);
                                        if (res) {
                                          BlocProvider.of<WorkBloc>(context)
                                              .add(Deleted(state.rush.id));
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: Colors.blue[300],
                                                  ),
                                                  SizedBox(width: 16),
                                                  Text('Input deleted'),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      shape: const CircleBorder(),
                                      fillColor: Colors.white,
                                      constraints: const BoxConstraints(
                                          minWidth: 48, minHeight: 48),
                                    ),
                                  ],
                                )
                              : RaisedButton(
                                  key: ValueKey(state),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 4,
                                    ),
                                    child: state is Ready
                                        ? StartWorkingText()
                                        : state is InProgress
                                            ? Text('STOP WORKING',
                                                style: textStyle)
                                            : state is Done
                                                ? Text('BACK HOME',
                                                    style: textStyle)
                                                : Container(),
                                  ),
                                  onPressed: () {
                                    if (state is Ready)
                                      BlocProvider.of<WorkBloc>(context).add(
                                        Started(DateTime.now()),
                                      );
                                    if (state is InProgress)
                                      BlocProvider.of<WorkBloc>(context).add(
                                        Stopped(DateTime.now()),
                                      );
                                  },
                                  color: Colors.indigo[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  splashColor:
                                      Colors.grey[400].withOpacity(0.5),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DoneWidget extends StatelessWidget {
  const DoneWidget({
    Key key,
    this.rush,
  }) : super(key: key);

  final Rush rush;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('DONE !', style: textStyle),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Started at :'),
                  Text(DateFormat('HH:mm').format(rush.startDate)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Ended at :'),
                  Text(DateFormat('HH:mm').format(rush.endDate)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total :'),
                  Text(rush.endDate.difference(rush.startDate).pretty()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WIPWidget extends StatefulWidget {
  const WIPWidget({
    Key key,
    @required this.startTime,
  }) : super(key: key);

  final DateTime startTime;

  @override
  _WIPWidgetState createState() => _WIPWidgetState();
}

class _WIPWidgetState extends State<WIPWidget> {
  Timer rebuildTimer;
  String timeAgo;

  @override
  void dispose() {
    rebuildTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    timeAgo = widget.startTime.timeAgo();
    rebuildTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {
        timeAgo = widget.startTime.timeAgo();
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Currently working\n (theoretically...)',
          style: textStyle,
        ),
        SizedBox(height: 8),
        Text(
          'Started ${widget.startTime.timeAgo()}',
          style: textStyle.copyWith(fontSize: 18),
        )
      ],
    );
  }
}

class StartWorkingText extends StatelessWidget {
  const StartWorkingText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'START WORKING ',
            style: textStyle,
          ),
          TextSpan(
            text: '💪',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
