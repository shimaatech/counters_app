import 'package:counters/persistent/persistent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef CounterOperationExecutor = Counter Function(Counter counter);

abstract class CounterOperation {

  String get name;

  IconData get iconData;

  Color get color;

  Counter execute(Counter counter);

  const CounterOperation();
}


class _CounterOperationIncrement extends CounterOperation {

  const _CounterOperationIncrement();

  @override
  Counter execute(Counter counter) {
    return counter.copyWith(value: counter.value + 1);
  }

  @override
  String get name => 'increment';

  @override
  IconData get iconData => Icons.add;

  @override
  Color get color => Colors.green;
}


class _CounterOperationDecrement extends CounterOperation {

  const _CounterOperationDecrement();

  @override
  Counter execute(Counter counter) {
    return counter.copyWith(value: counter.value - 1);
  }

  @override
  String get name => 'decrement';

  @override
  IconData get iconData => Icons.remove;

  @override
  Color get color => Colors.red;

}


class _CounterOperationReset extends CounterOperation {

  const _CounterOperationReset();

  @override
  Counter execute(Counter counter) {
    return counter.copyWith(value: 0);
  }

  @override
  String get name => 'reset';

  @override
  IconData get iconData => Icons.refresh;

  @override
  Color get color => Colors.black45;

}

class CounterOperations {

  CounterOperations._();

  static const CounterOperation increment = _CounterOperationIncrement();

  static const CounterOperation decrement = _CounterOperationDecrement();

  static const CounterOperation reset = _CounterOperationReset();

  static Map<String, CounterOperation> _operationsMap = _createOperationsMap();

  static Map<String, CounterOperation> _createOperationsMap() {
    return {
      increment.name: increment,
      decrement.name: decrement,
      reset.name: reset
    };
  }

  static CounterOperation of(String operation) {
    return _operationsMap[operation];
  }
}


