import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class WorldClockController extends GetxController {
  RxList<Map<String, String>> selectedTimeZones = <Map<String, String>>[].obs;
  RxString formattedTime = ''.obs;
  RxString formattedDateNDay = ''.obs;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    selectedTimeZones.assignAll(selectedTimeZones); // Load initial cities
    updateTime();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => updateTime());
  }

  void updateTime() {
    formattedTime.value = DateFormat('hh:mm:ss a').format(DateTime.now());
    formattedDateNDay.value = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  void addCity(Map<String, String> city) {
    if (!selectedTimeZones.contains(city)) {
      selectedTimeZones.add(city);
    }
  }

  void removeCity(Map<String, String> city) {
    selectedTimeZones.remove(city);
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}
