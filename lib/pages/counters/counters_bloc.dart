import 'dart:async';

import 'package:bloc_component/bloc_component.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:counters/services/services.dart';
import 'package:counters/utils/scrolling_utils.dart';
import 'package:flutter/material.dart';


class CountersState extends BlocState {
  final List<Counter> counters;

  CountersState({@required this.counters});

  @override
  List<Object> get props => [counters];
}

class _StateCreatingCounter extends StateLoading {}


class _CountersEvent extends BlocEvent {}

class _EventRefresh extends _CountersEvent {}

class _EventCreateCounter extends _CountersEvent {}

class _EventReorder extends _CountersEvent {
  final int oldPosition;
  final int newPosition;

  _EventReorder(this.oldPosition, this.newPosition);

  @override
  List<Object> get props => [oldPosition, newPosition];
}

class CountersBloc extends BaseBloc {
  CountersBloc(this._countersService) {
    _counterUpdatedSubscription = _countersService.onCounterUpdated.listen((counter) {
      add(_EventRefresh());
    });

    _counterRemovedSubscription = _countersService.onCounterRemoved.listen((counter) {
      add(_EventRefresh());
    });
  }

  final CountersService _countersService;

  List<Counter> _counters;

  final ScrollController scrollController = ScrollController();

  StreamSubscription<Counter> _counterUpdatedSubscription;
  StreamSubscription<Counter> _counterRemovedSubscription;

  int _lastAddedCounterId;

  bool counterInEditMode(Counter counter) {
    return _lastAddedCounterId == counter.id;
  }

  @override
  Stream<BlocState> eventToState(BlocEvent event) async* {
    _lastAddedCounterId = null;
    if (event is _EventCreateCounter) {
      yield _StateCreatingCounter();
      _lastAddedCounterId = await _countersService.addCounter(Counter.create());
    } else if (event is _EventRefresh) {
      // do nothing... refreshState() will be called in the end of this method
    } else if (event is _EventReorder) {
      // need to update counter new position
      final Counter counter = _counters[event.oldPosition];
      final newPosition = counter.position + event.newPosition - event.oldPosition;
      await _countersService.updateCounter(counter.copyWith(position: newPosition));
    }

    yield* _refreshState();

  }

  void createCounter() {
    add(_EventCreateCounter());
    ScrollingUtils.animateToTop(scrollController);
  }


  void reorderCounter(int oldPosition, int newPosition) {
    add(_EventReorder(oldPosition, newPosition));
  }

  @override
  Stream<StateInitializing> initialize() async* {
    _counters = await _countersService.getCounters();
  }

  @override
  Stream<BlocState> onInitialized() async* {
    yield CountersState(counters: _counters);
  }

  @override
  Future<void> close() async {
    await super.close();
    _counterUpdatedSubscription.cancel();
    _counterRemovedSubscription.cancel();
    scrollController.dispose();
  }

  Stream<CountersState> _refreshState() async* {
    _counters = await _countersService.getCounters();
    yield CountersState(counters: _counters);
  }

}
