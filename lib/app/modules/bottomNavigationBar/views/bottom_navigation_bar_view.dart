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
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Scaffold(
          body: PageView(
            controller: pageController,
            children: controller.pages,
            onPageChanged: (index) {
              controller.changeTab(index);
            },
          ),
          bottomNavigationBar: Obx(
            () => CustomNavigationBar(
              value: themeController.isLightMode.value,
              currentIndex: controller.activeTabIndex.value,
              onTap: (index) {
                Utils.hapticFeedback();
                controller.changeTab(index);
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool value;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: value ? Colors.white : kprimaryBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(Icons.alarm, 0, 'Alarm'),
          buildNavItem(
            Icons.timer_outlined,
            1,
            'StopWatch',
          ),
          buildNavItem(
            Icons.timelapse_outlined,
            2,
            'Timer',
          ),
        ],
      ),
    );
  }

  Widget buildNavItem(
    IconData icon,
    int index,
    String label,
  ) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: currentIndex == index ? kprimaryColor : Colors.grey,
            size: currentIndex == index ? 30 : 25,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: value ? Colors.black : Colors.white,
                width: 0.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: Text(
                label.tr,
                style: TextStyle(
                  color: currentIndex == index ? kprimaryColor : Colors.grey,
                  fontSize: currentIndex == index ? 13 : 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
