import 'package:flutter/cupertino.dart';

class ScrollingUtils {
  static void animateToTop(ScrollController scrollController,
      [duration = 200]) {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: duration),
      curve: Curves.easeInOut,
    );
  }

  static void animateToEnd(ScrollController scrollController,
      [duration = 200]) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 1,
      duration: Duration(milliseconds: duration),
      curve: Curves.easeInOut,
    );
  }
}
