import 'package:counters/persistent/persistent.dart';

class Counter extends PersistentCounter {

  // TODO do we really need this constructor?
  // TODO why not used named constructor... For example Counter.create (not a factory method)
  Counter(int id, String title, int value, DateTime created, int position)
      : super(id: id, title: title, value: value, created: created, position: position);

  /// Used for creating new instances
  factory Counter.create({String title = 'Counter title', int value = 0}) =>
      Counter(null, title, value, null, null);


  factory Counter.fromPersistent(
      PersistentCounter persistent) {
    return Counter(
        persistent.id, persistent.title, persistent.value, persistent.created, persistent.position);
  }

  @override
  Counter copyWith({int id, String title, int value, DateTime created, int position}) {
    // modifying id is not allowed
    assert(id == null);
    return Counter.fromPersistent(
        super.copyWith(id: this.id, title: title, value: value, created: created, position: position));
  }

//  Future<List<CounterLog>> getLogs() {
//    return _counterLogDao?.getRecords(id);
//  }

}
