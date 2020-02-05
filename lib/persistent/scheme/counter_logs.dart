import 'package:moor/moor.dart';

@DataClassName('PersistentCounterLog')
class CounterLogs extends Table {

  IntColumn get id => integer().autoIncrement()();

  // We don't declare ON DELETE CASCADE here...
  // It's the responsibility of user to delete related counter logs when counter
  // is deleted. This should be done in transaction...
  // We simply don't use ON DELETE CASCADE because the in memory database doesn't
  // support that...
  IntColumn get counterId => integer().customConstraint('REFERENCES counters(id)')();

  TextColumn get operationName => text().withLength(min: 1, max: 20)();

  IntColumn get value => integer()();

  DateTimeColumn get time => dateTime().withDefault(currentDateAndTime)();

}
