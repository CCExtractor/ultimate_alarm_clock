import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/bottomNavigationBar/controllers/bottom_navigation_bar_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class BottomNavigationBarView extends GetView<BottomNavigationBarController> {
  final PageController pageController = PageController();
  final ThemeController themeController = Get.find<ThemeController>();

  BottomNavigationBarView({super.key});
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
              icon: const Icon(Icons.alarm),
              label: 'Alarm'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.timer_outlined),
              label: 'StopWatch'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.timelapse_outlined),
              label: 'Timer'.tr,
            ),
          ],
          onTap: (index) {
            Utils.hapticFeedback();
            controller.changeTab(index);
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          currentIndex: controller.activeTabIndex.value,
          selectedLabelStyle: TextStyle(
            color: kprimaryColor,
            fontSize: 14,
            decoration: TextDecoration.underline,
            decorationColor:
                themeController.isLightMode.value ? Colors.black : Colors.white,
            decorationThickness: 0.8,
          ),
        ),
      ),
    );
  }
}
