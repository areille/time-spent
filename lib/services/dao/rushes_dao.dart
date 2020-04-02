import 'package:moor/moor.dart';

import '../../data/db/database.dart';

part 'rushes_dao.g.dart';

@UseDao(tables: [Rushes])
class RushesDao extends DatabaseAccessor<Database> with _$RushesDaoMixin {
  RushesDao(Database db) : super(db);
}
