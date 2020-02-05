import 'package:bloc/bloc.dart';
import 'package:bloc_component/bloc_component.dart';
import 'package:counters/app/app.dart';
import 'package:counters/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';

void main() {
  _setup();
  runApp(CountersApp());
}

void _setup() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  StateBuilder.builderConfig = BaseStateBuilderConfig();
}


class AppStateBuilderConfig extends BaseStateBuilderConfig {

  @override
  Widget loadingIndicator(BuildContext context, [StateLoading loading]) {
    return AppConstants.defaultProgressIndicator;
  }

}