import 'package:intl/intl.dart';
import 'package:moor/moor.dart';

import '../../data/db/database.dart';

part 'rushes_dao.g.dart';

@UseDao(tables: [Rushes])
class RushesDao extends DatabaseAccessor<Database> with _$RushesDaoMixin {
  RushesDao(Database db) : super(db);

  Future<int> saveRush(Rush rush) async {
    return into(rushes).insert(rush);
  }

  Future<void> deleteRush(int rushId) async {
    return (delete(rushes)..where((r) => r.id.equals(rushId))).go();
  }

  Future<List<Rush>> get getRushes => select(rushes).get();

  Future<Map<String, List<Rush>>> get monthlySortedRushes async {
    final Map<String, List<Rush>> mSortedRushes = {};
    final rushes = await getRushes;

    for (final rush in rushes) {
      final month = DateFormat('MMMM yyyy').format(rush.startDate);
      if (mSortedRushes.containsKey(month))
        mSortedRushes[month].add(rush);
      else
        mSortedRushes.addAll({
          month: [rush]
        });
    }
    return mSortedRushes;
  }
}
