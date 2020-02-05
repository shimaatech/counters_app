// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class PersistentCounter extends DataClass
    implements Insertable<PersistentCounter> {
  final int id;
  final String title;
  final int value;
  final DateTime created;
  final int position;
  PersistentCounter(
      {@required this.id,
      @required this.title,
      @required this.value,
      @required this.created,
      @required this.position});
  factory PersistentCounter.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return PersistentCounter(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      value: intType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
      created: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created']),
      position:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}position']),
    );
  }
  factory PersistentCounter.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PersistentCounter(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      value: serializer.fromJson<int>(json['value']),
      created: serializer.fromJson<DateTime>(json['created']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'value': serializer.toJson<int>(value),
      'created': serializer.toJson<DateTime>(created),
      'position': serializer.toJson<int>(position),
    };
  }

  @override
  CountersCompanion createCompanion(bool nullToAbsent) {
    return CountersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
    );
  }

  PersistentCounter copyWith(
          {int id, String title, int value, DateTime created, int position}) =>
      PersistentCounter(
        id: id ?? this.id,
        title: title ?? this.title,
        value: value ?? this.value,
        created: created ?? this.created,
        position: position ?? this.position,
      );
  @override
  String toString() {
    return (StringBuffer('PersistentCounter(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('value: $value, ')
          ..write('created: $created, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(title.hashCode,
          $mrjc(value.hashCode, $mrjc(created.hashCode, position.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PersistentCounter &&
          other.id == this.id &&
          other.title == this.title &&
          other.value == this.value &&
          other.created == this.created &&
          other.position == this.position);
}

class CountersCompanion extends UpdateCompanion<PersistentCounter> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> value;
  final Value<DateTime> created;
  final Value<int> position;
  const CountersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.value = const Value.absent(),
    this.created = const Value.absent(),
    this.position = const Value.absent(),
  });
  CountersCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
    this.value = const Value.absent(),
    this.created = const Value.absent(),
    this.position = const Value.absent(),
  }) : title = Value(title);
  CountersCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<int> value,
      Value<DateTime> created,
      Value<int> position}) {
    return CountersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      created: created ?? this.created,
      position: position ?? this.position,
    );
  }
}

class $CountersTable extends Counters
    with TableInfo<$CountersTable, PersistentCounter> {
  final GeneratedDatabase _db;
  final String _alias;
  $CountersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn('title', $tableName, false,
        minTextLength: 1, maxTextLength: 50);
  }

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  GeneratedIntColumn _value;
  @override
  GeneratedIntColumn get value => _value ??= _constructValue();
  GeneratedIntColumn _constructValue() {
    return GeneratedIntColumn('value', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _createdMeta = const VerificationMeta('created');
  GeneratedDateTimeColumn _created;
  @override
  GeneratedDateTimeColumn get created => _created ??= _constructCreated();
  GeneratedDateTimeColumn _constructCreated() {
    return GeneratedDateTimeColumn('created', $tableName, false,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _positionMeta = const VerificationMeta('position');
  GeneratedIntColumn _position;
  @override
  GeneratedIntColumn get position => _position ??= _constructPosition();
  GeneratedIntColumn _constructPosition() {
    return GeneratedIntColumn('position', $tableName, false,
        defaultValue: const Constant(0));
  }

  @override
  List<GeneratedColumn> get $columns => [id, title, value, created, position];
  @override
  $CountersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'counters';
  @override
  final String actualTableName = 'counters';
  @override
  VerificationContext validateIntegrity(CountersCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (d.value.present) {
      context.handle(
          _valueMeta, value.isAcceptableValue(d.value.value, _valueMeta));
    }
    if (d.created.present) {
      context.handle(_createdMeta,
          created.isAcceptableValue(d.created.value, _createdMeta));
    }
    if (d.position.present) {
      context.handle(_positionMeta,
          position.isAcceptableValue(d.position.value, _positionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersistentCounter map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PersistentCounter.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(CountersCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.value.present) {
      map['value'] = Variable<int, IntType>(d.value.value);
    }
    if (d.created.present) {
      map['created'] = Variable<DateTime, DateTimeType>(d.created.value);
    }
    if (d.position.present) {
      map['position'] = Variable<int, IntType>(d.position.value);
    }
    return map;
  }

  @override
  $CountersTable createAlias(String alias) {
    return $CountersTable(_db, alias);
  }
}

class PersistentCounterLog extends DataClass
    implements Insertable<PersistentCounterLog> {
  final int id;
  final int counterId;
  final String operationName;
  final int value;
  final DateTime time;
  PersistentCounterLog(
      {@required this.id,
      @required this.counterId,
      @required this.operationName,
      @required this.value,
      @required this.time});
  factory PersistentCounterLog.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return PersistentCounterLog(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      counterId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}counter_id']),
      operationName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}operation_name']),
      value: intType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
      time:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}time']),
    );
  }
  factory PersistentCounterLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PersistentCounterLog(
      id: serializer.fromJson<int>(json['id']),
      counterId: serializer.fromJson<int>(json['counterId']),
      operationName: serializer.fromJson<String>(json['operationName']),
      value: serializer.fromJson<int>(json['value']),
      time: serializer.fromJson<DateTime>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'counterId': serializer.toJson<int>(counterId),
      'operationName': serializer.toJson<String>(operationName),
      'value': serializer.toJson<int>(value),
      'time': serializer.toJson<DateTime>(time),
    };
  }

  @override
  CounterLogsCompanion createCompanion(bool nullToAbsent) {
    return CounterLogsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      counterId: counterId == null && nullToAbsent
          ? const Value.absent()
          : Value(counterId),
      operationName: operationName == null && nullToAbsent
          ? const Value.absent()
          : Value(operationName),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      time: time == null && nullToAbsent ? const Value.absent() : Value(time),
    );
  }

  PersistentCounterLog copyWith(
          {int id,
          int counterId,
          String operationName,
          int value,
          DateTime time}) =>
      PersistentCounterLog(
        id: id ?? this.id,
        counterId: counterId ?? this.counterId,
        operationName: operationName ?? this.operationName,
        value: value ?? this.value,
        time: time ?? this.time,
      );
  @override
  String toString() {
    return (StringBuffer('PersistentCounterLog(')
          ..write('id: $id, ')
          ..write('counterId: $counterId, ')
          ..write('operationName: $operationName, ')
          ..write('value: $value, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          counterId.hashCode,
          $mrjc(
              operationName.hashCode, $mrjc(value.hashCode, time.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PersistentCounterLog &&
          other.id == this.id &&
          other.counterId == this.counterId &&
          other.operationName == this.operationName &&
          other.value == this.value &&
          other.time == this.time);
}

class CounterLogsCompanion extends UpdateCompanion<PersistentCounterLog> {
  final Value<int> id;
  final Value<int> counterId;
  final Value<String> operationName;
  final Value<int> value;
  final Value<DateTime> time;
  const CounterLogsCompanion({
    this.id = const Value.absent(),
    this.counterId = const Value.absent(),
    this.operationName = const Value.absent(),
    this.value = const Value.absent(),
    this.time = const Value.absent(),
  });
  CounterLogsCompanion.insert({
    this.id = const Value.absent(),
    @required int counterId,
    @required String operationName,
    @required int value,
    this.time = const Value.absent(),
  })  : counterId = Value(counterId),
        operationName = Value(operationName),
        value = Value(value);
  CounterLogsCompanion copyWith(
      {Value<int> id,
      Value<int> counterId,
      Value<String> operationName,
      Value<int> value,
      Value<DateTime> time}) {
    return CounterLogsCompanion(
      id: id ?? this.id,
      counterId: counterId ?? this.counterId,
      operationName: operationName ?? this.operationName,
      value: value ?? this.value,
      time: time ?? this.time,
    );
  }
}

class $CounterLogsTable extends CounterLogs
    with TableInfo<$CounterLogsTable, PersistentCounterLog> {
  final GeneratedDatabase _db;
  final String _alias;
  $CounterLogsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _counterIdMeta = const VerificationMeta('counterId');
  GeneratedIntColumn _counterId;
  @override
  GeneratedIntColumn get counterId => _counterId ??= _constructCounterId();
  GeneratedIntColumn _constructCounterId() {
    return GeneratedIntColumn('counter_id', $tableName, false,
        $customConstraints: 'REFERENCES counters(id)');
  }

  final VerificationMeta _operationNameMeta =
      const VerificationMeta('operationName');
  GeneratedTextColumn _operationName;
  @override
  GeneratedTextColumn get operationName =>
      _operationName ??= _constructOperationName();
  GeneratedTextColumn _constructOperationName() {
    return GeneratedTextColumn('operation_name', $tableName, false,
        minTextLength: 1, maxTextLength: 20);
  }

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  GeneratedIntColumn _value;
  @override
  GeneratedIntColumn get value => _value ??= _constructValue();
  GeneratedIntColumn _constructValue() {
    return GeneratedIntColumn(
      'value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _timeMeta = const VerificationMeta('time');
  GeneratedDateTimeColumn _time;
  @override
  GeneratedDateTimeColumn get time => _time ??= _constructTime();
  GeneratedDateTimeColumn _constructTime() {
    return GeneratedDateTimeColumn(
      'time',
      $tableName,
      false,
    )..clientDefault = () => DateTime.now();
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, counterId, operationName, value, time];
  @override
  $CounterLogsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'counter_logs';
  @override
  final String actualTableName = 'counter_logs';
  @override
  VerificationContext validateIntegrity(CounterLogsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.counterId.present) {
      context.handle(_counterIdMeta,
          counterId.isAcceptableValue(d.counterId.value, _counterIdMeta));
    } else if (isInserting) {
      context.missing(_counterIdMeta);
    }
    if (d.operationName.present) {
      context.handle(
          _operationNameMeta,
          operationName.isAcceptableValue(
              d.operationName.value, _operationNameMeta));
    } else if (isInserting) {
      context.missing(_operationNameMeta);
    }
    if (d.value.present) {
      context.handle(
          _valueMeta, value.isAcceptableValue(d.value.value, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (d.time.present) {
      context.handle(
          _timeMeta, time.isAcceptableValue(d.time.value, _timeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersistentCounterLog map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PersistentCounterLog.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(CounterLogsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.counterId.present) {
      map['counter_id'] = Variable<int, IntType>(d.counterId.value);
    }
    if (d.operationName.present) {
      map['operation_name'] =
          Variable<String, StringType>(d.operationName.value);
    }
    if (d.value.present) {
      map['value'] = Variable<int, IntType>(d.value.value);
    }
    if (d.time.present) {
      map['time'] = Variable<DateTime, DateTimeType>(d.time.value);
    }
    return map;
  }

  @override
  $CounterLogsTable createAlias(String alias) {
    return $CounterLogsTable(_db, alias);
  }
}

abstract class _$CountersDatabase extends GeneratedDatabase {
  _$CountersDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $CountersTable _counters;
  $CountersTable get counters => _counters ??= $CountersTable(this);
  $CounterLogsTable _counterLogs;
  $CounterLogsTable get counterLogs => _counterLogs ??= $CounterLogsTable(this);
  CounterDao _counterDao;
  CounterDao get counterDao =>
      _counterDao ??= CounterDao(this as CountersDatabase);
  CounterLogDao _counterLogDao;
  CounterLogDao get counterLogDao =>
      _counterLogDao ??= CounterLogDao(this as CountersDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [counters, counterLogs];
}
