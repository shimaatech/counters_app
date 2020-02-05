import 'package:counters/persistent/persistent.dart';
import 'package:moor/moor.dart';

part 'counter_dao.g.dart';

@UseDao(tables: [Counters])
class CounterDao extends DatabaseAccessor<CountersDatabase>
    with _$CounterDaoMixin {
  CounterDao(CountersDatabase db) : super(db);

  Future<List<Counter>> listCounters([int limit]) async {
    var query = select(counters)
      // order by creation time descending
      ..orderBy([
        (c) => OrderingTerm(expression: c.position, mode: OrderingMode.asc)
      ]);
    if (limit != null) {
      query = query..limit(limit);
    }
    List<PersistentCounter> persistentCounters = await query.get();
    return persistentCounters.map((e) => _persistentToCounter(e)).toList();
  }

  Future<int> insertCounter(Counter counter) {
    return transaction<int>(() async {
      int id = await into(counters).insert(counter);
      // increment position of all counters by 1
      await customUpdate('UPDATE counters SET position = position + 1',
          updates: {counters});
      return id;
    });
  }

  Future<Counter> findCounter(int id) async {
    PersistentCounter persistentCounter = await (select(counters)
          ..where((counter) => counter.id.equals(id)))
        .getSingle();
    return _persistentToCounter(persistentCounter);
  }

  Future<void> updateCounter(Counter counter) async {
    return transaction(() async {
      Counter oldCounter = await findCounter(counter.id);
      // update new counters positions if the counter's position was updated
      await updateCountersPositions(oldCounter.position, counter.position);
      await (update(counters)..where((c) => c.id.equals(counter.id)))
          .write(counter);
    });
  }

  Future<void> updateCountersPositions(int oldPosition, int newPosition) async {
    if (newPosition > oldPosition) {
      await customUpdate(
        'UPDATE counters SET position = position - 1 WHERE (position > ? and position <= ?)',
        variables: [
          Variable.withInt(oldPosition),
          Variable.withInt(newPosition)
        ],
        updates: {counters},
      );
    } else if (newPosition < oldPosition) {
      await customUpdate(
        'UPDATE counters SET position = position + 1 WHERE (position >= ? and position < ?)',
        variables: [
          Variable.withInt(newPosition),
          Variable.withInt(oldPosition)
        ],
        updates: {counters},
      );
    }
  }

  Future<int> deleteCounter(Counter counter) async {
    return deleteCounterById(counter.id);
  }

  Future<int> deleteCounterById(int id) async {
    // not sure how to cascade here...
    // maybe we should use ON DELETE CASCADE... it doesn't work in the
    // memory db, but maybe it works on device (on a real db...) try that...
    int result;
    await transaction(() async {
      result = await (delete(counters)..where((c) => c.id.equals(id))).go();
      if (result > 0) {
        await db.counterLogDao.deleteCounterRecords(id);
      }
    });
    return result;
  }

  /// Streams

  Stream<Counter> watchCounter(int id) {
    return (select(counters)..where((counter) => counter.id.equals(id)))
        .watchSingle()
        .asyncMap((e) => _persistentToCounter(e));
  }

  Stream<List<Counter>> watchCounters() {
    return (select(counters)
          ..orderBy([
            (c) => OrderingTerm(expression: c.position, mode: OrderingMode.asc)
          ]))
        .watch()
        .asyncMap((counters) =>
            counters.map((e) => _persistentToCounter(e)).toList());
  }

  Counter _persistentToCounter(PersistentCounter persistent) {
    if (persistent != null) {
      return Counter.fromPersistent(persistent);
    }
    return null;
  }
}
