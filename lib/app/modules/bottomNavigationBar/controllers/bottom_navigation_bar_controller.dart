import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/secure_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/views/home_view.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/views/stopwatch_view.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/timer_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/views/timer_view.dart';

class BottomNavigationBarController extends GetxController
    with WidgetsBindingObserver {
  RxInt activeTabIndex = 0.obs;
  RxBool isTimerRunning = false.obs;

  final _secureStorageProvider = SecureStorageProvider();

  TimerController timerController = Get.find<TimerController>();

  List<Widget> pages = [
    HomeView(),
    StopwatchView(),
    TimerView(),
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _loadSavedState();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _saveState();
    }
  }

  void _loadSavedState() async {
    activeTabIndex.value = await _secureStorageProvider.readTabIndex();
  }

  void _saveState() async {
    await _secureStorageProvider.writeTabIndex(
      tabIndex: activeTabIndex.value,
    );
  }

  void changeTab(int index) {
    activeTabIndex.value = index;

    if (index == 0 &&
        (timerController.isTimerRunning.value || isTimerRunning.value)) {
      timerController.saveTimerStateToStorage();
    }
  }
}
