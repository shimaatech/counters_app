import 'package:counters/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_home.dart';

class CountersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO what about theme?
    // TODO what about routing?
    return MaterialApp(
      navigatorKey: Get.key,
      title: AppConstants.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppHome(),
    );

  }

}