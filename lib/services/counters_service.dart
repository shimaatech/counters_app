import 'package:counters/persistent/persistent.dart';
import 'package:counters/model/model.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:rxdart/rxdart.dart';


class CountersService extends SimpleService {

  CountersService(this.counterDao, this.counterLogDao);

  final CounterDao counterDao;
  final CounterLogDao counterLogDao;

  final PublishSubject<Counter> _counterAddedSubject = PublishSubject();
  Stream<Counter> get onCounterAdded => _counterAddedSubject.stream;

  final PublishSubject<Counter> _counterRemovedSubject = PublishSubject();
  Stream<Counter> get onCounterRemoved => _counterRemovedSubject.stream;

  final PublishSubject<CounterLog> _counterLogAddedSubject = PublishSubject();
  Stream<CounterLog> get onCounterLogAdded => _counterLogAddedSubject.stream;

  final PublishSubject<CounterLog> _counterLogRemovedSubject = PublishSubject();
  Stream<CounterLog> get onCounterLogRemoved => _counterLogRemovedSubject.stream;

  final PublishSubject<Counter> _counterUpdatedSubject = PublishSubject();
  Stream<Counter> get onCounterUpdated => _counterUpdatedSubject.stream;


  Future<int> addCounter(Counter counter) async {
    int id = await counterDao.insertCounter(counter);
    _counterAddedSubject.add(counter);
    return id;

  }

  Future<Counter> updateCounter(Counter counter) async {
    await counterDao.updateCounter(counter);
    _counterUpdatedSubject.add(counter);
    return counter;
  }

  Future<Counter> applyCounterOperation(
      Counter counter, CounterOperation operation) async {
    if (operation == CounterOperations.reset && counter.value == 0) {
      return counter;
    }
    counter = operation.execute(counter);
    return counterDao.transaction<Counter>(() async {
      await updateCounter(counter);
      CounterLog log = CounterLog.create(counter: counter, operation: operation);
      await counterLogDao.insertRecord(log);
      _counterLogAddedSubject.add(log);
      return counter;
    });
  }

  Future<List<Counter>> getCounters([int limit]) async {
    return counterDao.listCounters(limit);
  }

  Stream<List<Counter>> watchCounters() {
    return counterDao.watchCounters();
  }

  Stream<List<CounterLog>> watchLogs(Counter counter) {
    return counterLogDao.watchRecords(counter.id);
  }

  Future<List<CounterLog>> getLogs(Counter counter, [int limit]) {
    return counterLogDao.getRecords(counter.id, limit);
  }

  Future<void> deleteCounter(Counter counter) async {
    await counterDao.deleteCounter(counter);
    _counterRemovedSubject.add(counter);
  }

  @override
  void dispose() {
    super.dispose();
    _counterAddedSubject.close();
    _counterRemovedSubject.close();
    _counterLogAddedSubject.close();
    _counterLogRemovedSubject.close();
    _counterUpdatedSubject.close();
  }
}
