// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String name;
  final double hourlyBillRate;
  Project({@required this.id, @required this.name, this.hourlyBillRate});
  factory Project.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Project(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      hourlyBillRate: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}hourly_bill_rate']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || hourlyBillRate != null) {
      map['hourly_bill_rate'] = Variable<double>(hourlyBillRate);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      hourlyBillRate: hourlyBillRate == null && nullToAbsent
          ? const Value.absent()
          : Value(hourlyBillRate),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hourlyBillRate: serializer.fromJson<double>(json['hourlyBillRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'hourlyBillRate': serializer.toJson<double>(hourlyBillRate),
    };
  }

  Project copyWith({int id, String name, double hourlyBillRate}) => Project(
        id: id ?? this.id,
        name: name ?? this.name,
        hourlyBillRate: hourlyBillRate ?? this.hourlyBillRate,
      );
  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hourlyBillRate: $hourlyBillRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, hourlyBillRate.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.hourlyBillRate == this.hourlyBillRate);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> hourlyBillRate;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hourlyBillRate = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.hourlyBillRate = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Project> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<double> hourlyBillRate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hourlyBillRate != null) 'hourly_bill_rate': hourlyBillRate,
    });
  }

  ProjectsCompanion copyWith(
      {Value<int> id, Value<String> name, Value<double> hourlyBillRate}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hourlyBillRate: hourlyBillRate ?? this.hourlyBillRate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hourlyBillRate.present) {
      map['hourly_bill_rate'] = Variable<double>(hourlyBillRate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hourlyBillRate: $hourlyBillRate')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProjectsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hourlyBillRateMeta =
      const VerificationMeta('hourlyBillRate');
  GeneratedRealColumn _hourlyBillRate;
  @override
  GeneratedRealColumn get hourlyBillRate =>
      _hourlyBillRate ??= _constructHourlyBillRate();
  GeneratedRealColumn _constructHourlyBillRate() {
    return GeneratedRealColumn(
      'hourly_bill_rate',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, hourlyBillRate];
  @override
  $ProjectsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'projects';
  @override
  final String actualTableName = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hourly_bill_rate')) {
      context.handle(
          _hourlyBillRateMeta,
          hourlyBillRate.isAcceptableOrUnknown(
              data['hourly_bill_rate'], _hourlyBillRateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Project.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(_db, alias);
  }
}

class Rush extends DataClass implements Insertable<Rush> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final int projectId;
  final bool billable;
  Rush(
      {@required this.id,
      this.startDate,
      this.endDate,
      @required this.projectId,
      @required this.billable});
  factory Rush.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Rush(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      startDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}start_date']),
      endDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}end_date']),
      projectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}project_id']),
      billable:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}billable']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int>(projectId);
    }
    if (!nullToAbsent || billable != null) {
      map['billable'] = Variable<bool>(billable);
    }
    return map;
  }

  RushesCompanion toCompanion(bool nullToAbsent) {
    return RushesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      billable: billable == null && nullToAbsent
          ? const Value.absent()
          : Value(billable),
    );
  }

  factory Rush.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Rush(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      projectId: serializer.fromJson<int>(json['projectId']),
      billable: serializer.fromJson<bool>(json['billable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'projectId': serializer.toJson<int>(projectId),
      'billable': serializer.toJson<bool>(billable),
    };
  }

  Rush copyWith(
          {int id,
          DateTime startDate,
          DateTime endDate,
          int projectId,
          bool billable}) =>
      Rush(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        projectId: projectId ?? this.projectId,
        billable: billable ?? this.billable,
      );
  @override
  String toString() {
    return (StringBuffer('Rush(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('projectId: $projectId, ')
          ..write('billable: $billable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          startDate.hashCode,
          $mrjc(endDate.hashCode,
              $mrjc(projectId.hashCode, billable.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Rush &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.projectId == this.projectId &&
          other.billable == this.billable);
}

class RushesCompanion extends UpdateCompanion<Rush> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> projectId;
  final Value<bool> billable;
  const RushesCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.projectId = const Value.absent(),
    this.billable = const Value.absent(),
  });
  RushesCompanion.insert({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    @required int projectId,
    this.billable = const Value.absent(),
  }) : projectId = Value(projectId);
  static Insertable<Rush> custom({
    Expression<int> id,
    Expression<DateTime> startDate,
    Expression<DateTime> endDate,
    Expression<int> projectId,
    Expression<bool> billable,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (projectId != null) 'project_id': projectId,
      if (billable != null) 'billable': billable,
    });
  }

  RushesCompanion copyWith(
      {Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> projectId,
      Value<bool> billable}) {
    return RushesCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      projectId: projectId ?? this.projectId,
      billable: billable ?? this.billable,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (billable.present) {
      map['billable'] = Variable<bool>(billable.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RushesCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('projectId: $projectId, ')
          ..write('billable: $billable')
          ..write(')'))
        .toString();
  }
}

class $RushesTable extends Rushes with TableInfo<$RushesTable, Rush> {
  final GeneratedDatabase _db;
  final String _alias;
  $RushesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _startDateMeta = const VerificationMeta('startDate');
  GeneratedDateTimeColumn _startDate;
  @override
  GeneratedDateTimeColumn get startDate => _startDate ??= _constructStartDate();
  GeneratedDateTimeColumn _constructStartDate() {
    return GeneratedDateTimeColumn(
      'start_date',
      $tableName,
      true,
    );
  }

  final VerificationMeta _endDateMeta = const VerificationMeta('endDate');
  GeneratedDateTimeColumn _endDate;
  @override
  GeneratedDateTimeColumn get endDate => _endDate ??= _constructEndDate();
  GeneratedDateTimeColumn _constructEndDate() {
    return GeneratedDateTimeColumn(
      'end_date',
      $tableName,
      true,
    );
  }

  final VerificationMeta _projectIdMeta = const VerificationMeta('projectId');
  GeneratedIntColumn _projectId;
  @override
  GeneratedIntColumn get projectId => _projectId ??= _constructProjectId();
  GeneratedIntColumn _constructProjectId() {
    return GeneratedIntColumn(
      'project_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _billableMeta = const VerificationMeta('billable');
  GeneratedBoolColumn _billable;
  @override
  GeneratedBoolColumn get billable => _billable ??= _constructBillable();
  GeneratedBoolColumn _constructBillable() {
    return GeneratedBoolColumn('billable', $tableName, false,
        defaultValue: const Constant(true));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, startDate, endDate, projectId, billable];
  @override
  $RushesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'rushes';
  @override
  final String actualTableName = 'rushes';
  @override
  VerificationContext validateIntegrity(Insertable<Rush> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date'], _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date'], _endDateMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id'], _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('billable')) {
      context.handle(_billableMeta,
          billable.isAcceptableOrUnknown(data['billable'], _billableMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rush map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Rush.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $RushesTable createAlias(String alias) {
    return $RushesTable(_db, alias);
  }
}

abstract class _$DB extends GeneratedDatabase {
  _$DB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ProjectsTable _projects;
  $ProjectsTable get projects => _projects ??= $ProjectsTable(this);
  $RushesTable _rushes;
  $RushesTable get rushes => _rushes ??= $RushesTable(this);
  ProjectsDao _projectsDao;
  ProjectsDao get projectsDao => _projectsDao ??= ProjectsDao(this as DB);
  RushesDao _rushesDao;
  RushesDao get rushesDao => _rushesDao ??= RushesDao(this as DB);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [projects, rushes];
}
