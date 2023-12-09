import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPageController extends GetxController {
  RxInt currentIndex = 0.obs;
  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Page 1',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Page 2',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Page 3',
    ),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
