import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_alarm_clock/app/utils/utils_world_gmt_data.dart';
import 'package:ultimate_alarm_clock/app/utils/selected_cities.dart';

class SearchController extends GetxController {
  RxBool showCancelIcon = false.obs;
  RxList<Map<String, String>> filteredCities = <Map<String, String>>[].obs;
  TextEditingController searchController = TextEditingController();

  void searchKeyword(String query) {
    query = query.toLowerCase();
    filteredCities.value = cities.where((city) {
      return city['city']!.toLowerCase().contains(query) ||
          city['timezone']!.toLowerCase().contains(query) ||
          city['country']!.toLowerCase().contains(query);
    }).toList();
  }

  void clearSearch() {
    searchController.clear();
    filteredCities.clear(); // Clear the filtered cities list
  }


  void onCityTap(Map<String, String> city) {
    if (!selectedCities.contains(city)) {
      selectedCities.add(city);
    }
    Get.back(result: city);
  }

  void checkQueryEmptyOrNot(String text) {
    showCancelIcon.value = text.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    filteredCities.value = [];
  }
}
