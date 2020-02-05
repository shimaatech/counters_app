import 'package:bloc_component/bloc_component.dart';
import 'package:counters/model/model.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:counters/services/counters_service.dart';
import 'package:flutter/cupertino.dart';

class CounterItemState extends BlocState {
  final bool editMode;
  final Counter counter;

  CounterItemState({@required this.counter, this.editMode = false});

  @override
  List<Object> get props => [counter, editMode];
}


class _CounterEvent extends BlocEvent {}

class _EventOperate extends _CounterEvent {
  final CounterOperation operation;

  _EventOperate(this.operation);

  @override
  List<Object> get props => [operation];
}

class _EventEdit extends _CounterEvent {}

class _EventSave extends _CounterEvent {}

class _EventCancel extends _CounterEvent {}

class _EventDeleteCounter extends _CounterEvent {}

class CounterItemBloc extends BaseBloc {
  final TextEditingController titleController = TextEditingController();
  final CountersService _countersService;

  Counter _counter;
  bool _editMode;

  CounterItemBloc(this._countersService, this._counter, [this._editMode=false]) {
    if (_editMode) {
      edit();
    }
  }

  Counter get counter => _counter;

  @override
  BlocState get initialState => CounterItemState(counter: _counter, editMode: false);

  @override
  Stream<BlocState> eventToState(BlocEvent event) async* {

    if (event is _EventOperate) {
      await _handleCounterOperation(event.operation);
    } else if (event is _EventEdit) {
      await _enterEditMode();
    } else if (event is _EventSave) {
      await _saveCounterUpdates();
    } else if (event is _EventCancel) {
      _editMode = false;
    } else if (event is _EventDeleteCounter) {
      await _countersService.deleteCounter(counter);
      return;
    }

    yield CounterItemState(counter: _counter, editMode: _editMode);
  }

  void execOperation(CounterOperation operation) {
    add(_EventOperate(operation));
  }

  void edit() {
    add(_EventEdit());
  }

  void save() {
    add(_EventSave());
  }

  void cancelEditing() {
    add(_EventCancel());
  }

  void deleteCounter() {
    add(_EventDeleteCounter());
  }

  @override
  Future<void> close() async {
    await super.close();
    titleController.dispose();
  }

  Future<void> _handleCounterOperation(CounterOperation operation) async {
    _counter = await _countersService.applyCounterOperation(_counter, operation);
  }

  Future<void> _enterEditMode() async {
    titleController.text = _counter.title;
    // highlight the old title
    titleController.selection =
        TextSelection(baseOffset: 0, extentOffset: _counter.title.length);
    _editMode = true;
  }

  Future<void> _saveCounterUpdates() async {
    _counter = await _countersService
        .updateCounter(_counter.copyWith(title: titleController.text));
    _editMode = false;
  }
}
