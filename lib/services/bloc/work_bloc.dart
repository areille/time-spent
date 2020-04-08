import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../data/db/database.dart';
import '../dao/rushes_dao.dart';

class WorkBloc extends Bloc<WorkEvent, WorkState> {
  WorkBloc({@required this.rushesDao}) : assert(rushesDao != null);

  final RushesDao rushesDao;
  DateTime startDate;
  Rush rush;

  @override
  Stream<WorkState> mapEventToState(WorkEvent event) async* {
    if (event is Started) {
      startDate = event.time;
      yield InProgress(event.time);
    }
    if (event is Stopped) {
      rush = Rush(
        id: null,
        startDate: startDate,
        endDate: event.time,
        projectId: null,
      );
      yield Done(rush);
    }
    if (event is Saved) {
      await rushesDao.saveRush(rush);
      yield Ready();
    }
    if (event is Reset) {
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

class Saved extends WorkEvent {
  @override
  List<Object> get props => [];
}

class Reset extends WorkEvent {
  @override
  List<Object> get props => [];
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
