import 'dart:async';
import 'package:counters/model/counter_operation.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

void main() {
  CountersDatabase database;
  CounterDao counterDao;
  CounterLogDao counterLogDao;

  setUp(() {
    database = CountersDatabase(VmDatabase.memory(logStatements: true));
    counterDao = database.counterDao;
    counterLogDao = database.counterLogDao;
  });

  tearDown(() async {
    await database.close();
  });

  test('create counter', () async {
    final title = 'My Counter';
    final id = await counterDao.insertCounter(Counter.create(title: title));
    var counter = await counterDao.findCounter(id);
    expect(counter.id, id);
    expect(counter.title, title);
  });

  test('counter position', () async {
    await counterDao.insertCounter(Counter.create());
    await counterDao.insertCounter(Counter.create());

    List<Counter> counters = await counterDao.listCounters();
    expect(counters[0].position, 1);
    expect(counters[1].position, 2);
  });


  test('position update', () async {
    await counterDao.insertCounter(Counter.create());
    await counterDao.insertCounter(Counter.create());
    await counterDao.insertCounter(Counter.create());

    List<Counter> counters = await counterDao.listCounters();
    print(counters);

    expect(counters[0].id, 3);
    expect(counters[1].id, 2);
    expect(counters[2].id, 1);

    await counterDao.updateCounter(counters[0].copyWith(position: 2));
    counters = await counterDao.listCounters();
    print(counters);

    expect(counters[0].id, 2);
    expect(counters[1].id, 3);
    expect(counters[2].id, 1);

    await counterDao.insertCounter(Counter.create());
    counters = await counterDao.listCounters();

    expect(counters[0].id, 4);
    expect(counters[1].id, 2);
    expect(counters[2].id, 3);
    expect(counters[3].id, 1);

    await counterDao.updateCounter(counters[1].copyWith(position: 4));
    counters = await counterDao.listCounters();

    expect(counters[0].id, 4);
    expect(counters[1].id, 3);
    expect(counters[2].id, 1);
    expect(counters[3].id, 2);

    await counterDao.updateCounter(counters[3].copyWith(position: 1));
    counters = await counterDao.listCounters();

    expect(counters[0].id, 2);
    expect(counters[1].id, 4);
    expect(counters[2].id, 3);
    expect(counters[3].id, 1);

  });

  test('counter list', () async {

    final int numOfCounters = 10;
    for (int i=0; i<numOfCounters; i++) {
      await counterDao.insertCounter(Counter.create());
    }

    expect((await counterDao.listCounters()).length, numOfCounters);

    final int limit = 4;
    expect((await counterDao.listCounters(limit)).length, limit);
  });


  test('update counter', () async {
    final id = await counterDao.insertCounter(Counter.create());
    final counter = await counterDao.findCounter(id);
    expect(counter.id, id);

    final newTitle = 'Counter new title';
    await counterDao.updateCounter(counter.copyWith(title: newTitle));
    final updatedCounter = await counterDao.findCounter(id);
    expect(updatedCounter.title, newTitle);
  });

  test('delete counter', () async {
    final dao = counterDao;
    final id = await dao.insertCounter(Counter.create());
    final counter = await dao.findCounter(id);
    expect(counter.id, id);

    expect(await dao.deleteCounter(counter), 1);
    expect(await dao.findCounter(id), null);
  });

  test('counters list watch', () async {
    var updates = 0;
    Completer completer = Completer();
    counterDao.watchCounters().listen((counters) {
      updates++;
      completer.complete();
    });

    // wait for the first watch when the db is opened
    await completer.future;

    completer = Completer();
    await counterDao.insertCounter(Counter.create());
    await completer.future;

    completer = Completer();
    final id = await counterDao.insertCounter(Counter.create());
    await completer.future;

    final counter = await counterDao.findCounter(id);

    completer = Completer();
    await counterDao.updateCounter(counter.copyWith(title: 'new title'));
    await completer.future;

    completer = Completer();
    expect(await counterDao.deleteCounterById(id), 1);
    await completer.future;

    expect(updates, 5);
  });

  test('create and delete counter log', () async {
    final int counterId = await counterDao.insertCounter(Counter.create());
    final Counter counter = await counterDao.findCounter(counterId);

    await counterLogDao.insertRecord(CounterLog.create(
        counter: counter, operation: CounterOperations.increment));

    List<CounterLog> records = await counterLogDao.getRecords(counterId);
    print(records);
    expect(records.length, 1);

    expect(await counterLogDao.deleteRecord(records[0].id), 1);
    expect(await counterLogDao.getRecords(counterId), Iterable.empty());
  });

  test('multiple counter logs', () async {
    final int id1 = await counterDao.insertCounter(Counter.create());
    final int id2 = await counterDao.insertCounter(Counter.create());
    final int id3 = await counterDao.insertCounter(Counter.create());

    List<Counter> counters = await counterDao.listCounters();
    expect(counters.length, 3);

    await counterLogDao.insertRecord(CounterLog.create(
        counter: counters[2], operation: CounterOperations.increment));
    await counterLogDao.insertRecord(CounterLog.create(
        counter: counters[2], operation: CounterOperations.increment));
    await counterLogDao.insertRecord(CounterLog.create(
        counter: counters[2], operation: CounterOperations.increment));

    await counterLogDao.insertRecord(CounterLog.create(
        counter: counters[1], operation: CounterOperations.increment));

    expect((await counterLogDao.getRecords(counters[2].id)).length, 3);
    expect((await counterLogDao.getRecords(counters[1].id)).length, 1);
    expect((await counterLogDao.getRecords(counters[0].id)), Iterable.empty());

    await counterDao.deleteCounterById(id1);
    await counterLogDao.deleteCounterRecords(id1);

    expect(await counterDao.findCounter(id1), null);
    expect((await counterLogDao.getRecords(id1)), Iterable.empty());

    expect((await counterLogDao.getRecords(id2)).length, 1);
    expect((await counterLogDao.getRecords(id3)), Iterable.empty());
  });
}
