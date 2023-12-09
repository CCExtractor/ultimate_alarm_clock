import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ultimate_alarm_clock/app/modules/home/views/home_view.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';

class LandingPageView extends StatefulWidget {
  const LandingPageView({super.key});

  @override
  State<LandingPageView> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPageView> {
  ThemeController themeController = Get.find<ThemeController>();
  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Page 1',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Page 2',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Page 3',
    ),
  ];
  int currentIndex = 0;
  List<Widget> _pages = [
    HomeView(),
    Text("2"),
    Text("3"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
