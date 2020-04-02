import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/bloc/work_bloc.dart';
import '../utils/datetime_ext.dart';
import '../widgets/clock.dart';

const kAnimationDuration = const Duration(milliseconds: 400);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    fontStyle: FontStyle.italic,
    color: Colors.white,
  );
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
                AnimatedCrossFade(
                  duration: kAnimationDuration,
                  firstChild: Container(),
                  secondChild: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Work in progress...',
                          style: textStyle,
                        ),
                        SizedBox(height: 8),
                        if (state is InProgress)
                          Text(
                            'Started ${state.startTime.timeAgo()}',
                            style: textStyle.copyWith(fontSize: 18),
                          )
                      ],
                    ),
                  ),
                  crossFadeState: state is InProgress
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
                Expanded(
                  child: Center(
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 4,
                        ),
                        child: AnimatedCrossFade(
                          duration: kAnimationDuration,
                          firstChild: StartWorkingText(textStyle: textStyle),
                          secondChild: Text('STOP WORKING', style: textStyle),
                          crossFadeState: state is Ready
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
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

class StartWorkingText extends StatelessWidget {
  const StartWorkingText({
    Key key,
    @required this.textStyle,
  }) : super(key: key);

  final TextStyle textStyle;

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
