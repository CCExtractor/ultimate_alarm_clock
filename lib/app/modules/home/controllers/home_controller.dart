import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/alarm_model.dart';
import 'package:ultimate_alarm_clock/app/data/models/providers/firestore_provider.dart';
import 'package:ultimate_alarm_clock/main.dart';

class HomeController extends GetxController {
  late Stream<QuerySnapshot> streamAlarms;

  final count = 0.obs;
  @override
  void onInit() async {
    streamAlarms = FirestoreDb.getAlarms();

    super.onInit();
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
