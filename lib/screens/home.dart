import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pedantic/pedantic.dart';

import '../data/db/database.dart';
import '../services/bloc/work_bloc.dart';
import '../utils/delete_dialog.dart';
import '../utils/extensions.dart';
import '../widgets/clock.dart';
import 'list.dart';

const kAnimationDuration = Duration(milliseconds: 400);
const textStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 24,
  fontStyle: FontStyle.italic,
  color: Colors.white,
);

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
                const Positioned(
                  top: 28,
                  left: 4,
                  child: _ListButton(),
                ),
                const Positioned(
                  top: 28,
                  right: 4,
                  child: _SettingsButton(),
                ),
                Column(
                  children: [
                    const SizedBox(height: 24),
                    AnimatedContainer(
                      duration: kAnimationDuration,
                      curve: Curves.easeInOut,
                      height: state is Ready
                          ? MediaQuery.of(context).size.height / 2
                          : thirdHeight,
                      child: const ClockWidget(),
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
                    SizedBox(
                      height: thirdHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: kAnimationDuration,
                            child: state is Done
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      RawMaterialButton(
                                        onPressed: () {
                                          BlocProvider.of<WorkBloc>(context)
                                              .add(Saved());
                                          Flushbar(
                                            icon: const Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.greenAccent,
                                            ),
                                            message: 'Input saved !',
                                            duration:
                                                const Duration(seconds: 3),
                                            margin: const EdgeInsets.all(8),
                                            borderRadius: 8,
                                          ).show(context);
                                        },
                                        shape: const CircleBorder(),
                                        fillColor: Colors.white,
                                        constraints: const BoxConstraints(
                                            minWidth: 48, minHeight: 48),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      RawMaterialButton(
                                        onPressed: () async {
                                          final res =
                                              await deleteDialog(context);
                                          if (res) {
                                            BlocProvider.of<WorkBloc>(context)
                                                .add(Reset());
                                            unawaited(Flushbar(
                                              icon: const Icon(
                                                Icons.info_outline,
                                                color: Colors.blueAccent,
                                              ),
                                              message: 'Input deleted',
                                              duration:
                                                  const Duration(seconds: 3),
                                              margin: const EdgeInsets.all(8),
                                              borderRadius: 8,
                                            ).show(context));
                                          }
                                        },
                                        shape: const CircleBorder(),
                                        fillColor: Colors.white,
                                        constraints: const BoxConstraints(
                                            minWidth: 48, minHeight: 48),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )
                                : RaisedButton(
                                    key: ValueKey(state),
                                    onPressed: () {
                                      if (state is Ready) {
                                        BlocProvider.of<WorkBloc>(context).add(
                                          Started(DateTime.now()),
                                        );
                                      }
                                      if (state is InProgress) {
                                        BlocProvider.of<WorkBloc>(context).add(
                                          Stopped(DateTime.now()),
                                        );
                                      }
                                    },
                                    color: Colors.indigo[400],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    splashColor:
                                        Colors.grey[400].withOpacity(0.5),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 4,
                                      ),
                                      child: state is Ready
                                          ? const StartWorkingText()
                                          : state is InProgress
                                              ? const Text(
                                                  'STOP WORKING',
                                                  style: textStyle,
                                                )
                                              : Container(),
                                    ),
                                  ),
                          ),
                          AnimatedContainer(
                            duration: kAnimationDuration,
                            height: state is Ready ? 20 : 0,
                          ),
                          AnimatedCrossFade(
                            duration: kAnimationDuration,
                            firstChild: const _StartedEarlierButton(),
                            secondChild: Container(),
                            crossFadeState: state is Ready
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                          ),
                        ],
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

class _StartedEarlierButton extends StatelessWidget {
  const _StartedEarlierButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      splashColor: Colors.grey[400].withOpacity(0.5),
      onPressed: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time == null) {
          return;
        }
        final dTime = time.toDate();
        if (dTime.isAfter(DateTime.now())) {
          unawaited(showDialog(
              context: context,
              child: AlertDialog(
                content: const Text(
                  'Can you work in the future ?',
                ),
                actions: [
                  FlatButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('CLOSE'),
                  ),
                ],
              )));
        } else {
          BlocProvider.of<WorkBloc>(context).add(
            Started(dTime),
          );
        }
      },
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            Colors.pink.shade300,
            Colors.orange.shade400,
          ],
        ).createShader(
          Rect.fromLTWH(
            0,
            0,
            bounds.width,
            bounds.height,
          ),
        ),
        child: const Text(
          'Started earlier ?',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
      shape: const CircleBorder(),
      fillColor: Colors.white,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      child: const Icon(Icons.settings),
    );
  }
}

class _ListButton extends StatelessWidget {
  const _ListButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ListPage()),
        );
      },
      shape: const CircleBorder(),
      fillColor: Colors.white,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      child: const Icon(Icons.list),
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
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('DONE !', style: textStyle),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Started at :'),
                  Text(DateFormat('HH:mm').format(rush.startDate)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Ended at :'),
                  Text(DateFormat('HH:mm').format(rush.endDate)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Total :'),
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
        const Text(
          'Currently working\n (theoretically...)',
          style: textStyle,
        ),
        const SizedBox(height: 8),
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
      text: const TextSpan(
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
