import 'dart:math';

import 'package:counters/model/model.dart';
import 'package:counters/persistent/database.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:counters/services/counters_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

void main() {

  CountersDatabase db;
  CountersService service;

  setUp(() async {
    db = CountersDatabase(VmDatabase.memory(logStatements: true));
    service = CountersService(db.counterDao, db.counterLogDao);
  });

  tearDown(() async {
    service.dispose();
    db.close();
  });


  test('creating, updating and deleting counters', () async {
    await service.addCounter(Counter.create());
    await service.addCounter(Counter.create());

    List<Counter> counters = await service.getCounters();
    expect(counters.length, 2);

    // Test updating title
    String title = 'New Counter title';
    service.updateCounter(counters[0].copyWith(title: title));
    counters = await service.getCounters();
    expect(counters[0].title, title);

    // Test some operations
    Counter counter = counters[0];
    expect(counter.value, 0);
    counter = await service.applyCounterOperation(counter, CounterOperations.increment);
    counter = await service.applyCounterOperation(counter, CounterOperations.increment);
    counter = await service.applyCounterOperation(counter, CounterOperations.increment);
    counter = await service.applyCounterOperation(counter, CounterOperations.decrement);
    expect(counter.value, 2);

    counters = await service.getCounters();
    expect(counters[0].value, counter.value);

    counter = await service.applyCounterOperation(counter, CounterOperations.reset);
    expect(counter.value, 0);
    counters = await service.getCounters();
    expect(counters[0].value, 0);


    // Test deleting counter
    await service.deleteCounter(counter);
    counters = await service.getCounters();
    expect(counters.length, 1);

  });
}