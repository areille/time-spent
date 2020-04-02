import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/bloc/work_bloc.dart';
import '../utils/datetime_ext.dart';
import '../widgets/clock.dart';

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
  Widget scaleTransition(Widget widget, Animation<double> anim) =>
      ScaleTransition(child: widget, scale: anim);

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
        child: BlocBuilder<WorkBloc, WorkState>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(height: 24),
                AnimatedContainer(
                  duration: kAnimationDuration,
                  curve: Curves.easeInOut,
                  height: state is Ready
                      ? MediaQuery.of(context).size.height / 2
                      : MediaQuery.of(context).size.height / 3,
                  child: ClockWidget(),
                ),
                AnimatedSwitcher(
                  duration: kAnimationDuration,
                  transitionBuilder: scaleTransition,
                  child: Builder(
                    builder: (_) {
                      if (state is InProgress) {
                        return WIPWidget(startTime: state.startTime);
                      }
                      return Container();
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 4,
                        ),
                        child: AnimatedSwitcher(
                          duration: kAnimationDuration,
                          transitionBuilder: scaleTransition,
                          child: Builder(
                            builder: (_) {
                              if (state is Ready) return StartWorkingText();
                              if (state is InProgress)
                                return Text('STOP WORKING', style: textStyle);
                              return Container();
                            },
                          ),
                        ),
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
                      splashColor: Colors.grey[400].withOpacity(0.5),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: kAnimationDuration,
                  height: state is Ready ? 24 : 0,
                )
              ],
            );
          },
        ),
      ),
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
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Work in progress...',
            style: textStyle,
          ),
          SizedBox(height: 8),
          Text(
            'Started ${widget.startTime.timeAgo()}',
            style: textStyle.copyWith(fontSize: 18),
          )
        ],
      ),
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
