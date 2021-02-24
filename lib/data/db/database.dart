import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/dao/projects_dao.dart';
import '../../services/dao/rushes_dao.dart';

part 'database.g.dart';

@DataClassName('Rush')
class Rushes extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get projectId => integer()();
  BoolColumn get billable => boolean().withDefault(const Constant(true))();
}

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get hourlyBillRate => real().nullable()();
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
    Projects,
    Rushes,
  ],
  daos: [
    ProjectsDao,
    RushesDao,
  ],
)
class DB extends _$DB {
  DB() : super(_openConnection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        beforeOpen: (openingDetails) async {
          // WARNING : THIS METHODS DESTROYS THE DB ON EACH APP START
          final m = Migrator(this);
          await Future.wait(
              [for (final t in allTables) m.deleteTable(t.actualTableName)]);
          await m.createAll();
        },
      );
}
