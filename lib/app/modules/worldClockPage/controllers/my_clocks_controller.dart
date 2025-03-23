import 'dart:async';
import 'package:get/get.dart';

class MyClocksController extends GetxController {
  var formattedTime = ''.obs;
  var formattedDate = ''.obs;
  var formattedDay = ''.obs;
  Timer? timer;

  void updateTime(String timezone) {
    _updateTimeForCity(timezone);

    timer?.cancel(); // Cancel existing timer before starting a new one
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeForCity(timezone);
    });
  }

  void _updateTimeForCity(String gmtOffset) {
    DateTime now = DateTime.now().toUtc();
    RegExp regex = RegExp(r'GMT([+-]\d{2}):(\d{2})');
    Match? match = regex.firstMatch(gmtOffset);

    if (match != null) {
      int hours = int.parse(match.group(1)!);
      int minutes = int.parse(match.group(2)!);
      DateTime cityTime = now.add(Duration(hours: hours, minutes: minutes));

      formattedTime.value = '${cityTime.hour}:${cityTime.minute.toString().padLeft(2, '0')}:${cityTime.second}';
      formattedDate.value = '${cityTime.day}/${cityTime.month}/${cityTime.year}';
      formattedDay.value =
      const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
        'Sunday'][cityTime.weekday - 1];
    } else {
      formattedTime.value = 'Invalid Time';
      formattedDate.value = 'Invalid Date';
      formattedDay.value = 'Invalid Day';
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
