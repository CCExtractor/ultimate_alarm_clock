import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/bottomNavigationBar/controllers/bottom_navigation_bar_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class BottomNavigationBarView extends GetView<BottomNavigationBarController> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: controller.pages,
        onPageChanged: (index) {
          controller.changeTab(index);
        },
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          useLegacyColorScheme: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: 'Alarm'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              label: 'StopWatch'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timelapse_outlined),
              label: 'Timer'.tr,
            ),
          ],
          onTap: (index) {
            Utils.hapticFeedback();
            controller.changeTab(index);
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          currentIndex: controller.activeTabIndex.value,
        ),
      ),
    );
  }
}

