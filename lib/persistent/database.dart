import 'dart:io';

import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'persistent.dart';
import 'package:moor/moor.dart';


part 'database.g.dart';

@UseMoor(
  tables: [Counters, CounterLogs],
  daos: [CounterDao, CounterLogDao],
)
class CountersDatabase extends _$CountersDatabase {

  CountersDatabase(QueryExecutor e) : super(e);

  CountersDatabase.open(String dbName): super(_openConnection(dbName));

  @override
  int get schemaVersion => 1;
}


LazyDatabase _openConnection(String dbName) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, dbName));
    return VmDatabase(file);
  });
}