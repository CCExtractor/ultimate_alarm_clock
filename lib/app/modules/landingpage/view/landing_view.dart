import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/home/views/home_view.dart';
import 'package:ultimate_alarm_clock/app/modules/landingpage/controller/landing_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

class LandingPageView extends GetView<LandingPageController> {
  LandingPageView({Key? key}) : super(key: key);

  final List<Widget> _pages = [
    HomeView(),
    Text("2"),
    Text("3"),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          items: controller.items,
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.currentIndex.value = index;
          },
        ),
      ),
    );
  }
}
