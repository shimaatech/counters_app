import 'package:bloc_component/bloc_component.dart';
import 'package:counters/app_context.dart';
import 'package:counters/pages/app_page_view.dart';
import 'package:counters/pages/counters/counters_bloc.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:counters/services/counters_service.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

import 'counter_item.dart';

class CountersPage extends Component<CountersBloc> {
  @override
  CountersBloc createBloc(BuildContext context) {
    return CountersBloc(AppContext().locate<CountersService>());
  }

  @override
  ComponentView<CountersBloc> createView(CountersBloc bloc) {
    return CountersPageView(bloc);
  }
}

class CountersPageView extends AppPageView<CountersBloc> {
  CountersPageView(CountersBloc bloc) : super(bloc);

  @override
  Widget buildContent(BuildContext context) {
    return stateBuilder<CountersState>(
      builder: _buildCountersList,
    );
  }

  @override
  FloatingActionButton get floatingAction {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _createCounter,
    );
  }

  void _createCounter() {
    bloc.createCounter();
  }

  Widget _buildCountersList(BuildContext context, CountersState state) {
    return CustomScrollView(
      controller: bloc.scrollController,
      slivers: <Widget>[
        ReorderableSliverList(
          delegate: ReorderableSliverChildListDelegate(
            _createCounterItems(context, state),
          ),
          onReorder: bloc.reorderCounter,
        )
      ],
    );
  }

  List<Widget> _createCounterItems(BuildContext context, CountersState state) {
    return state.counters
        .map((counter) => _createCounterItem(
            context, counter, bloc.counterInEditMode(counter)))
        .toList();
  }

  Widget _createCounterItem(
      BuildContext context, Counter counter, bool editMode) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.list,
              color: Colors.grey,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CounterItem(
                  counter,
                  editMode: editMode,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
