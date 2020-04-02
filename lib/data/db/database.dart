import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart';

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

getApplicationDocumentsDirectory() {}

@UseMoor(tables: [Rushes, Projects])
class Database extends _$Database {
  Database() : super(_openConnection);

  @override
  int get schemaVersion => 1;
}
