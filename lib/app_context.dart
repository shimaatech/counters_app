import 'package:counters/app_constants.dart';
import 'package:counters/persistent/dao/counter_dao.dart';
import 'package:counters/persistent/dao/counter_log_dao.dart';
import 'package:counters/persistent/database.dart';
import 'package:counters/services/counters_service.dart';
import 'package:flutter_base/flutter_base.dart';

class AppContext extends BaseAppContext {
  static final AppContext _instance = AppContext._internal();

  factory AppContext() {
    return _instance;
  }

  AppContext._internal();

  ServicesSetup _services = ServicesSetup();
  DBSetup _db = DBSetup();

  @override
  Future<void> setup() async {
    await _db.setup(locator);
    await _services.setup(locator);
  }
}

class DBSetup extends ContextSetup {
  @override
  Future<void> setup(Locator locator) async {
    locator.registerSingleton(
      (locator) => CountersDatabase.open(AppConstants.dbName),
    );

    locator.registerSingleton(
      (locator) => locator.locate<CountersDatabase>().counterDao,
    );

    locator.registerSingleton(
      (locator) => locator.locate<CountersDatabase>().counterLogDao,
    );
  }
}

class ServicesSetup extends ContextSetup {
  @override
  Future<void> setup(Locator locator) async {
    locator.registerSingleton((locator) => CountersService(
          locator.locate<CounterDao>(),
          locator.locate<CounterLogDao>(),
        ),);
  }
}
