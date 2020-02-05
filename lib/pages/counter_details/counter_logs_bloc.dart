import 'dart:async';

import 'package:bloc_component/bloc_component.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:counters/services/counters_service.dart';
import 'package:counters/utils/scrolling_utils.dart';
import 'package:flutter/cupertino.dart';

class CounterLogsBloc extends BaseBloc {
  CounterLogsBloc(this._countersService, this.counter) {
    _logAddedSubscription = _countersService.onCounterLogAdded.listen((log) {
      ScrollingUtils.animateToTop(scrollController);
    });
  }

  final CountersService _countersService;
  final Counter counter;

  Stream<List<CounterLog>> get logsStream =>
      _countersService.watchLogs(counter);

  // initial list for fast loading...
  List<CounterLog> _initialLogs;

  List<CounterLog> get initialLogs => _initialLogs;

  final ScrollController scrollController = ScrollController();

  StreamSubscription<CounterLog> _logAddedSubscription;

  @override
  Stream<BlocState> eventToState(BlocEvent event) async* {}

  @override
  Stream<StateInitializing> initialize() async* {
    _initialLogs = await _countersService.getLogs(counter, 20);
  }

  @override
  Future<void> close() async {
    await super.close();
    _logAddedSubscription.cancel();
    scrollController.dispose();
  }
}
