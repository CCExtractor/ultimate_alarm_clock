import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/bottomNavigationBar/controllers/bottom_navigation_bar_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class BottomNavigationBarView extends GetView<BottomNavigationBarController> {
  const BottomNavigationBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.activeTabIndex.value,
          children: controller.pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          useLegacyColorScheme: false,
          items:  [
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Alarm'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              label: 'StopWatch'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Timer'.tr,
            ),
          ],
          onTap: (index) {
            Utils.hapticFeedback();
            controller.changeTab(index);
          },
          currentIndex: controller.activeTabIndex.value,
        ),
      ),
    );
  }
}
