import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

import '../../data/db/database.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  WorkBloc({@required this.context}) : super(Ready());

  final BuildContext context;

  RushesCompanion rush = const RushesCompanion();

  @override
  Stream<WorkState> mapEventToState(WorkEvent event) async* {
    if (event is Started) {
      rush = rush.copyWith(
        projectId: Value(event.projectId),
        startDate: Value(event.time),
      );
      yield InProgress(event.time);
    }
    if (event is Stopped) {
      rush.copyWith(endDate: Value(event.time));
      await context.read<DB>().rushesDao.saveRush(rush);
      yield Done(rush);
    }
  }
}

// EVENTS

abstract class WorkEvent extends Equatable {}

class Started extends WorkEvent {
  Started(this.projectId, this.time);

  final int projectId;
  final DateTime time;

  @override
  List<Object> get props => [projectId, time];
}

class Stopped extends WorkEvent {
  Stopped(this.time);

  final DateTime time;

  @override
  List<Object> get props => [time];
}

// STATES

abstract class WorkState extends Equatable {
  @override
  List<Object> get props => [];
}

class Ready extends WorkState {}

class InProgress extends WorkState {
  InProgress(this.startTime);

  final DateTime startTime;

  @override
  List<Object> get props => [startTime];
}

class Done extends WorkState {
  Done(this.rush);

  final RushesCompanion rush;

  @override
  List<Object> get props => [rush];
}
