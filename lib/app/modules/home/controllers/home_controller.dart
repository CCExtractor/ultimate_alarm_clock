import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/main.dart';

class HomeController extends GetxController {
  late Stream<List<AlarmModel>> streamAlarms;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    streamAlarms = objectbox.getAlarms();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
