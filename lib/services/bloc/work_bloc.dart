import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:time_spent/data/db/database.dart';

import '../dao/rushes_dao.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  WorkBloc({@required this.rushesDao}) : assert(rushesDao != null);

  final RushesDao rushesDao;
  DateTime startDate;

  @override
  Stream<WorkState> mapEventToState(WorkEvent event) async* {
    if (event is Started) {
      startDate = event.time;
      yield InProgress(event.time);
    }
    if (event is Stopped) {
      final rush = Rush(
        id: null,
        startDate: startDate,
        endDate: event.time,
        projectId: null,
      );
      await rushesDao.saveRush(rush);
      yield Done(rush);
    }
    if (event is Deleted) {
      await rushesDao.deleteRush(event.id);
      yield Ready();
    }
  }

  @override
  WorkState get initialState => Ready();
}

// EVENTS

abstract class WorkEvent extends Equatable {}

class Started extends WorkEvent {
  Started(this.time);

  final DateTime time;

  @override
  List<Object> get props => [time];
}

class Stopped extends WorkEvent {
  Stopped(this.time);

  final DateTime time;

  @override
  List<Object> get props => [time];
}

class Deleted extends WorkEvent {
  Deleted(this.id);

  final int id;

  @override
  List<Object> get props => [id];
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

  final Rush rush;

  @override
  List<Object> get props => [rush];
}
