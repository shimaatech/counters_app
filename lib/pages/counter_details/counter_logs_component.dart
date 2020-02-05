import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:bloc_component/bloc_component.dart';
import 'package:counters/app_context.dart';
import 'package:counters/pages/counter_details/counter_logs_bloc.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:counters/services/counters_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';

class CounterLogsComponent extends Component<CounterLogsBloc> {
  final Counter counter;

  CounterLogsComponent(this.counter);

  @override
  CounterLogsBloc createBloc(BuildContext context) {
    return CounterLogsBloc(AppContext().locate<CountersService>(), counter);
  }

  @override
  ComponentView<CounterLogsBloc> createView(CounterLogsBloc bloc) {
    return CounterLogsView(bloc);
  }
}

class CounterLogsView extends ComponentView<CounterLogsBloc> {
  CounterLogsView(CounterLogsBloc bloc) : super(bloc);

  @override
  Widget buildView(BuildContext context) {
    return AnimatedStreamList<CounterLog>(
      scrollController: bloc.scrollController,
      // using initial list will make things faster (even when fetching
      // the whole data into the initial list
      initialList: bloc.initialLogs,
      streamList: bloc.logsStream,
      itemBuilder: (counterLog, index, context, animation) {
        return _buildCounterLogItem(context, counterLog, animation);
      },
      itemRemovedBuilder: (counterLog, index, context, animation) {
        return _removeCounterLog(context, counterLog, animation);
      },
    );
  }

  Widget _buildCounterLogItem(BuildContext context, CounterLog counterLog,
      Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              counterLog.operation.iconData,
              color: counterLog.operation.color,
            ),
            title: Text(
              counterLog.value.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(TimeUtils.formatTime(counterLog.time, timeFormat: 'HH:mm:ss')),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _removeCounterLog(BuildContext context, CounterLog counterLog,
      Animation<double> animation) {
    // currently not supported
    return Container();
  }
}
