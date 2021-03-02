import 'package:intl/intl.dart';
import 'package:moor/moor.dart';

import '../../data/db/database.dart';

part 'rushes_dao.g.dart';

@UseDao(tables: [Rushes])
class RushesDao extends DatabaseAccessor<DB> with _$RushesDaoMixin {
  RushesDao(DB db) : super(db);

  Future<int> saveRush(RushesCompanion rush) async {
    return into(rushes).insert(rush);
  }

  Future<void> deleteRush(int rushId) async {
    return (delete(rushes)..where((r) => r.id.equals(rushId))).go();
  }

  Future<List<Rush>> get getRushes => select(rushes).get();

  Future<List<Rush>> getProjectRushes(int projectId) =>
      (select(rushes)..where((rush) => rush.projectId.equals(projectId))).get();

  Stream<List<Rush>> get watchRushes => select(rushes).watch();

  Stream<List<Rush>> watchProjectRushes(int projectId) =>
      (select(rushes)..where((rush) => rush.projectId.equals(projectId)))
          .watch();

  Stream<Map<DateTime, List<Rush>>> watchProjectRushesByDate(
    int projectId,
  ) async* {
    await for (final event in watchProjectRushes(projectId)) {
      final dailySortedRushes = <DateTime, List<Rush>>{};
      for (final rush in event) {
        final day = DateTime(
          rush.startDate.year,
          rush.startDate.month,
          rush.startDate.day,
        );
        if (dailySortedRushes.containsKey(day)) {
          dailySortedRushes[day].add(rush);
        } else {
          dailySortedRushes[day] = [rush];
        }
      }
      yield dailySortedRushes;
    }
  }

  Stream<Map<String, List<Rush>>> get watchMonthlySortedRushes async* {
    await for (final event in watchRushes) {
      final mSortedRushes = <String, List<Rush>>{};
      for (final rush in event) {
        final month = DateFormat('MMMM yyyy').format(rush.startDate);
        if (mSortedRushes.containsKey(month)) {
          mSortedRushes[month].add(rush);
        } else {
          mSortedRushes.addAll({
            month: [rush]
          });
        }
      }
      yield mSortedRushes;
    }
  }

  Stream<List<Rush>> watchRushesByMonth(String month) async* {
    await for (final event in watchRushes) {
      final rushes = List<Rush>.from([]);
      for (final rush in event) {
        final _month = DateFormat('MMMM yyyy').format(rush.startDate);
        if (month == _month) {
          rushes.add(rush);
        }
      }
      yield rushes;
    }
  }

  Stream<List<Rush>> watchRushesByDay(String day) async* {
    await for (final event in watchRushes) {
      final rushes = List<Rush>.from([]);
      for (final rush in event) {
        final _day = DateFormat('dd/MM').format(rush.startDate);
        if (day == _day) {
          rushes.add(rush);
        }
      }
      yield rushes;
    }
  }

  Future<void> deleteRushesForProject(int projectId) {
    return (delete(rushes)..where((rush) => rush.projectId.equals(projectId)))
        .go();
  }
}
