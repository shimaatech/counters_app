import 'package:bloc_component/bloc_component.dart';
import 'package:counters/pages/counters/counters_page.dart';
import 'package:flutter/material.dart';
import 'app_bloc.dart';

class AppHome extends Component<AppBloc> {

  @override
  AppBloc createBloc(BuildContext context) {
    return AppBloc();
  }

  @override
  ComponentView<AppBloc> createView(AppBloc bloc) {
    return AppHomeView(bloc);
  }

}


class AppHomeView extends ComponentView<AppBloc> {
  AppHomeView(AppBloc bloc) : super(bloc);

  @override
  Widget buildView(BuildContext context) {
    return CountersPage();
  }

}