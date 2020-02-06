import 'package:bloc_component/bloc_component.dart';
import 'package:counters/app_context.dart';
import 'package:counters/model/model.dart';
import 'package:counters/pages/counter_details/counter_details_page.dart';
import 'package:counters/pages/counters/counter_item_bloc.dart';
import 'package:counters/persistent/persistent.dart';
import 'package:counters/services/counters_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_editing_watcher/text_editing_watcher.dart';

class CounterItem extends Component<CounterItemBloc> {
  @protected
  final Counter counter;
  final bool editMode;

  CounterItem(this.counter, {this.editMode = false})
      : super(key: ValueKey<Counter>(counter));

  @override
  CounterItemBloc createBloc(BuildContext context) {
    return CounterItemBloc(
        AppContext().locate<CountersService>(), counter, editMode);
  }

  @override
  ComponentView<CounterItemBloc> createView(CounterItemBloc bloc) {
    return CounterItemView(bloc, this);
  }
}

class CounterItemView extends ComponentView<CounterItemBloc> {
  final CounterItem component;
  static const double iconPadding = 5.0;

  CounterItemView(CounterItemBloc bloc, this.component) : super(bloc);

  @override
  Widget buildView(BuildContext context) {
    return stateBuilder<CounterItemState>(
      builder: (context, state) => buildCounterWidget(context, state),
    );
  }

  @protected
  Widget buildCounterWidget(BuildContext context, CounterItemState state) {
    return buildCounterCard(context, state.counter, state.editMode);
  }

  @protected
  Widget buildRemoveButton() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(iconPadding),
        child: Icon(
          Icons.delete,
          color: Colors.black45,
          size: 25,
        ),
      ),
      onTap: () {
        Get.defaultDialog(
          title: 'Remove counter?',
          content: Text('Are you sure you want to remove counter "${bloc.counter.title}"?'),
          confirm: FlatButton(
            child: Text('Yes'),
            onPressed: () => {bloc.deleteCounter(), Get.back(), postCounterDelete()},
          ),
          cancel: FlatButton(
            child: Text('No'),
            onPressed: () => Get.back(),
          ),
        );
      },
    );
  }

  @protected
  Widget buildResetButton() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(iconPadding),
        child: Icon(
          CounterOperations.reset.iconData,
          color: CounterOperations.reset.color,
          size: 25,
        ),
      ),
      onTap: () {
        Get.defaultDialog(
          title: 'Reset counter?',
          content: Text('Are you sure you want to reset counter "${bloc.counter.title}"?'),
          confirm: FlatButton(
            child: Text('Yes'),
            onPressed: () => {bloc.execOperation(CounterOperations.reset), Get.back()},
          ),
          cancel: FlatButton(
            child: Text('No'),
            onPressed: () => Get.back(),
          ),
        );
      },
    );
  }

  @protected
  Widget buildSaveButton() {
    return TextEditingWatcher(
      controller: bloc.titleController,
      builder: (text) {
        return IconButton(
          padding: EdgeInsets.all(0),
          disabledColor: Colors.grey,
          color: Colors.lightGreenAccent,
          icon: Icon(
            Icons.done_outline,
            size: 25,
          ),
          onPressed: text.trim().isNotEmpty ? bloc.save : null,
        );
      },
    );
  }

  @protected
  Widget buildEditButton() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(iconPadding),
        child: Icon(
          Icons.edit,
          size: 25,
          color: Colors.black45,
        ),
      ),
      onTap: bloc.edit,
    );
  }

  @protected
  Widget buildDetailsButton(BuildContext context, Counter counter) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(iconPadding),
        child: Icon(
          Icons.subject,
          color: Colors.black45,
          size: 25,
        ),
      ),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => CounterDetailsPage(counter))),
    );
  }

  @protected
  Widget buildHeader(BuildContext context, Counter counter, bool editMode) {
    return DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    editMode ? buildSaveButton() : buildEditButton(),
                    editMode || !showDetailsButton
                        ? Container()
                        : buildDetailsButton(context, counter),
                  ],
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: buildTitle(counter.title, editMode),
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    editMode || counter.value == 0 ? Container() : buildResetButton(),
                    editMode ? Container() : buildRemoveButton(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @protected
  Widget buildTitle(String title, bool editMode) {
    TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.white);
    if (editMode) {
      return TextEditingWatcher(
        controller: bloc.titleController,
        builder: (text) => Container(
          width: 250,
          child: TextFormField(
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(),
              isDense: true,
            ),
            autofocus: true,
            controller: bloc.titleController,
            maxLength: 20,
            textAlign: TextAlign.center,
            style: textStyle..copyWith(fontWeight: FontWeight.bold),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: text.trim().isNotEmpty
                ? (value) => bloc.save()
                : (_) => bloc.cancelEditing(),
          ),
        ),
      );
    } else {
      return Text(
        title,
        style: textStyle,
      );
    }
  }

  @protected
  Widget buildValuePanel(int value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            CounterOperations.decrement.iconData,
            color: CounterOperations.decrement.color,
            size: 30,
          ),
          onPressed: () => bloc.execOperation(CounterOperations.decrement),
        ),
        Container(
          width: 100,
          alignment: Alignment.center,
          child: Text(
            value.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blue),
          ),
        ),
        IconButton(
          icon: Icon(
            CounterOperations.increment.iconData,
            color: CounterOperations.increment.color,
            size: 30,
          ),
          onPressed: () => bloc.execOperation(CounterOperations.increment),
        ),
      ],
    );
  }

  @protected
  Widget buildCounterCard(
      BuildContext context, Counter counter, bool editMode) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Card(
        child: Column(
          children: <Widget>[
            buildHeader(context, counter, editMode),
            SizedBox(height: 20),
            buildValuePanel(counter.value),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  @protected
  bool get showDetailsButton => true;

  @protected
  void postCounterDelete() {}

}
