import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/get_storage_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/home/controllers/home_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

class TestThemeController extends ThemeController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put<ThemeController>(TestThemeController());
    Get.put<GetStorageProvider>(GetStorageProvider());
  });

  tearDown(() {
    Get.reset();
  });

  test('onClose cancels all active home timers', () {
    final controller = HomeController();
    final periodicTimer = Timer.periodic(const Duration(minutes: 1), (_) {});
    final delayTimer = Timer(const Duration(minutes: 1), () {});
    final scheduleTimer = Timer(const Duration(minutes: 1), () {});

    controller.setTimersForTest(
      periodicTimer: periodicTimer,
      delayTimer: delayTimer,
      scheduleTimer: scheduleTimer,
    );

    expect(controller.isPeriodicTimerActiveForTest, isTrue);
    expect(controller.isDelayTimerActiveForTest, isTrue);
    expect(controller.isScheduleTimerActiveForTest, isTrue);

    controller.onClose();

    expect(controller.isPeriodicTimerActiveForTest, isFalse);
    expect(controller.isDelayTimerActiveForTest, isFalse);
    expect(controller.isScheduleTimerActiveForTest, isFalse);
  });
}
