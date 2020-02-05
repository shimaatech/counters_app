import 'package:moor/moor.dart';

@DataClassName('PersistentCounter')
class Counters extends Table {

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  IntColumn get value => integer().withDefault(const Constant(0))();
  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();
  IntColumn get position => integer().withDefault(const Constant(0))();

  // We can't use the UNIQUE constraint on position because it fails on update...
  //@override
  //List<String> get customConstraints => ['UNIQUE (position)'];

}