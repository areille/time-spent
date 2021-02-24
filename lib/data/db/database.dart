import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/dao/rushes_dao.dart';

part 'database.g.dart';

@DataClassName('Rush')
class Rushes extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get projectId => integer().nullable()();
}

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

LazyDatabase get _openConnection {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(
  tables: [
    Rushes,
    Projects,
  ],
  daos: [
    RushesDao,
  ],
)
class DB extends _$DB {
  DB() : super(_openConnection);

  @override
  int get schemaVersion => 1;
}
