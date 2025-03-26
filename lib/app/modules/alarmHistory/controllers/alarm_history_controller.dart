
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';

class AlarmHistoryController extends GetxController {
  RxList<Map<String, dynamic>> history = <Map<String, dynamic>>[].obs;

  @override
  Future<void> onInit() async {
    history.value = await IsarDb.getAllHistory();
    super.onInit();
  }
}