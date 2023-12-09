import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/home/views/home_view.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/view/stopwatch_view.dart';

class LandingPageController extends GetxController {
  RxInt currentIndex = 0.obs;
  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.alarm),
      label: 'Alarm',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.watch),
      label: 'Stopwatch',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.timer),
      label: 'Pomodoro',
    ),
  ];
  final List<Widget> pages = [
    HomeView(),
    StopWatchPage(),
    Text("3"),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
