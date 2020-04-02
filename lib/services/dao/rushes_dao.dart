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
}
