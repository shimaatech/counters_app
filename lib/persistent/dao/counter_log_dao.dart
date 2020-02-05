import 'package:counters/persistent/entity/counter_log.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:moor/moor.dart';

part 'counter_log_dao.g.dart';

@UseDao(tables: [CounterLogs])
class CounterLogDao extends DatabaseAccessor<CountersDatabase>
    with _$CounterLogDaoMixin {
  CounterLogDao(CountersDatabase db) : super(db);

  Future<int> insertRecord(CounterLog counterLog) {
    return into(counterLogs).insert(counterLog);
  }

  Future<int> deleteRecord(int id) {
    return (delete(counterLogs)
          ..where((counterLog) => counterLog.id.equals(id)))
        .go();
  }

  Future<int> deleteCounterRecords(int counterId) {
    return (delete(counterLogs)
          ..where((counterLog) => counterLog.counterId.equals(counterId)))
        .go();
  }

  Future<List<CounterLog>> getRecords(int counterId, [int limit]) async {
    var query = select(counterLogs)
      ..where((counterLog) => counterLog.counterId.equals(counterId))
      ..orderBy([
        (log) => OrderingTerm(expression: log.id, mode: OrderingMode.desc)
      ]);
    if (limit != null) {
      query.limit(limit);
    }
    List<PersistentCounterLog> logs = await query.get();
    return logs.map((log) => _persistentToCounterLog(log)).toList();
  }

  Stream<List<CounterLog>> watchRecords(int counterId) {
    return (select(counterLogs)
          ..where((counterLog) => counterLog.counterId.equals(counterId))
          ..orderBy([
            (log) => OrderingTerm(expression: log.id, mode: OrderingMode.desc)
          ]))
        .watch()
        .asyncMap((records) =>
            records.map((r) => _persistentToCounterLog(r)).toList());
  }

  CounterLog _persistentToCounterLog(PersistentCounterLog persistent) {
    return CounterLog.fromPersistent(persistent);
  }
}
