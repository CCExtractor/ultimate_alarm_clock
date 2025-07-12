import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/bottomNavigationBar/controllers/bottom_navigation_bar_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class BottomNavigationBarView extends GetView<BottomNavigationBarController> {
  PageController pageController = PageController();
  final ThemeController themeController = Get.find<ThemeController>();

  BottomNavigationBarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: controller.loadSavedState(),
        builder: (context, snapshot) {
          return Obx(() {
            if (controller.hasloaded.value) {
              pageController = PageController(initialPage: controller.activeTabIndex.value);
              return PageView(
                controller: pageController,
                children: controller.pages,
                onPageChanged: (index) {
                  controller.changeTab(index);
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                    kprimaryColor,
                  ),
                ),
              );
            }
          });
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
            pageController.jumpToPage(
              index,
            );
          },
          currentIndex: controller.activeTabIndex.value,
          selectedLabelStyle: TextStyle(
            color: kprimaryColor,
            fontSize: 14,
            decorationColor: themeController.primaryBackgroundColor.value,
            decorationThickness: 0.8,
          ),
        ),
      ),
    );
  }
}