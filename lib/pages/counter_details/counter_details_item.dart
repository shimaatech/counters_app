import 'package:bloc_component/bloc_component.dart';
import 'package:counters/pages/counters/counter_item.dart';
import 'package:counters/pages/counters/counter_item_bloc.dart';
import 'package:counters/persistent/entity/counter.dart';
import 'package:get/get.dart';

class CounterDetailsItem extends CounterItem {
  CounterDetailsItem(Counter counter) : super(counter);

  @override
  ComponentView<CounterItemBloc> createView(CounterItemBloc bloc) {
    return CounterDetailsItemView(bloc, this);
  }
}

class CounterDetailsItemView extends CounterItemView {
  CounterDetailsItemView(CounterItemBloc bloc, CounterItem component)
      : super(bloc, component);

  @override
  bool get showDetailsButton => false;

  @override
  void postCounterDelete() {
    Get.back();
  }
}
