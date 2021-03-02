import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/dao/projects_dao.dart';
import '../../services/dao/rushes_dao.dart';
import '../../utils/extensions.dart';

part 'database.g.dart';

@DataClassName('Rush')
class Rushes extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get projectId => integer()();
  BoolColumn get billable => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();
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

extension RushExtension on Rush {
  Duration get duration => endDate.difference(startDate);

  String get prettyInterval =>
      '${startDate.prettyHour()} - ${endDate.prettyHour()}';
}
