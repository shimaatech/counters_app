import 'package:counters/model/counter_operation.dart';
import 'package:counters/persistent/database.dart';
import 'package:counters/persistent/entity/counter.dart';
import 'package:flutter/cupertino.dart';

class CounterLog extends PersistentCounterLog {

  // TODO use Operation operation here, and String operationName in PersistentCounterLog...
  CounterLog(int id, int counterId, String operationName, int value, DateTime time)
      : super(id: id, counterId: counterId, operationName: operationName, value: value, time: time);

  factory CounterLog.create(
      {@required Counter counter, @required CounterOperation operation}) {
    return CounterLog(null, counter.id, operation.name, counter.value, null);
  }

  factory CounterLog.fromPersistent(
      PersistentCounterLog persistent) {
    return CounterLog(persistent.id, persistent.counterId, persistent.operationName,
        persistent.value, persistent.time);
  }

  CounterOperation get operation => CounterOperations.of(operationName);

  @override
  PersistentCounterLog copyWith(
      {int id, int counterId, String operationName, int value, DateTime time}) {
    assert(id == null && counterId == null);
    return CounterLog.fromPersistent(
        super.copyWith(
            id: this.id,
            counterId: this.counterId,
            operationName: operationName,
            value: value,
            time: time));
  }

}
