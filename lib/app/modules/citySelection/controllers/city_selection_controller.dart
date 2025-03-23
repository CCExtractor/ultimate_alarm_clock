import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/utils/utils_world_gmt_data.dart';
import 'package:ultimate_alarm_clock/app/utils/selected_cities.dart';

class CitySelectionController extends GetxController {
  ScrollController scrollController = ScrollController();
  RxMap<String, int> letterIndexMap = <String, int>{}.obs;
  RxString selectedLetter = "".obs;

  final List<String> alphabet = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
  ];

  void scrollToLetter(String letter) {
    if (letterIndexMap.containsKey(letter)) {
      int index = letterIndexMap[letter]!;
      scrollController.animateTo(
        index * 60.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onCityTap(Map<String, String> city) {
    selectedCities.add(city);
    Get.back(result: city);
  }

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < cities.length; i++) {
      String letter = cities[i]['city']![0];
      letterIndexMap[letter] = letterIndexMap[letter] ?? i;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
