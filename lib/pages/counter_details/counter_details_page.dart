import 'package:bloc_component/bloc_component.dart';
import 'package:counters/pages/app_page_view.dart';
import 'package:counters/pages/counter_details/counter_details_bloc.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:flutter/material.dart';

import 'counter_details_item.dart';
import 'counter_logs_component.dart';

class CounterDetailsPage extends Component<CounterDetailsBloc> {

  final Counter counter;

  CounterDetailsPage(this.counter);

  @override
  CounterDetailsBloc createBloc(BuildContext context) {
    return CounterDetailsBloc();
  }

  @override
  ComponentView<CounterDetailsBloc> createView(CounterDetailsBloc bloc) {
    return CounterDetailsView(bloc, this);
  }

}


class CounterDetailsView extends AppPageView<CounterDetailsBloc> {

  final CounterDetailsPage component;

  CounterDetailsView(CounterDetailsBloc bloc, this.component) : super(bloc);

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: <Widget>[
        CounterDetailsItem(component.counter),
        SizedBox(height: 20,),
        Expanded(child: CounterLogsComponent(component.counter)),
      ],
    );
  }

  @override
  String get title => component.counter.title;
}