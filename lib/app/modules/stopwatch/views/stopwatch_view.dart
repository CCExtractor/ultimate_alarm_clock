import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/stopwatch/controllers/stopwatch_controller.dart';
import 'package:ultimate_alarm_clock/app/routes/app_pages.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';

class StopwatchView extends GetView<StopwatchController> {
  StopwatchView({Key? key}) : super(key: key);
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height / 7.9),
        child: AppBar(
          toolbarHeight: height / 7.9,
          elevation: 0.0,
          centerTitle: true,
          actions: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return IconButton(
                  onPressed: () {
                    Utils.hapticFeedback();
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                  ),
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.75)
                      : kprimaryTextColor.withOpacity(0.75),
                  iconSize: 27,
                  // splashRadius: 0.000001,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  controller.result,
                  style: const TextStyle(
                      fontSize: 60.0, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: "start",
                  onPressed: controller.toggleTimer,
                  child: Obx(() => Icon(
                        controller.isTimerPaused.value
                            ? Icons.play_arrow
                            : Icons.pause,
                      )),
                ),
                // Reset button
                FloatingActionButton(
                  heroTag: "stop",
                  onPressed: controller.resetTime,
                  child: Icon(Icons.square_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
      endDrawer: Obx(
        () => Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          backgroundColor: themeController.isLightMode.value
              ? kLightSecondaryBackgroundColor
              : ksecondaryBackgroundColor,
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: kLightSecondaryColor),
                child: Center(
                  child: Row(
                    children: [
                      const Flexible(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            'assets/images/ic_launcher-playstore.png',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * 0.5,
                              child: Text(
                                'Ultimate Alarm Clock'.tr,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      color: themeController.isLightMode.value
                                          ? kprimaryTextColor
                                          : ksecondaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.5,
                              child: Text(
                                'v0.5.0'.tr,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: themeController.isLightMode.value
                                          ? kprimaryTextColor
                                          : ksecondaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Utils.hapticFeedback();
                  Get.back();
                  Get.toNamed('/settings');
                },
                contentPadding: const EdgeInsets.only(left: 20, right: 44),
                title: Text(
                  'Settings'.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryTextColor.withOpacity(0.8)
                            : kprimaryTextColor.withOpacity(0.8),
                      ),
                ),
                leading: Icon(
                  Icons.settings,
                  size: 26,
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.8)
                      : kprimaryTextColor.withOpacity(0.8),
                ),
              ),
              ListTile(
                onTap: () {
                  Utils.hapticFeedback();
                  Get.back();
                  Get.toNamed(Routes.ABOUT);
                },
                contentPadding: const EdgeInsets.only(left: 20, right: 44),
                title: Text(
                  'About'.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: themeController.isLightMode.value
                            ? kLightPrimaryTextColor.withOpacity(0.8)
                            : kprimaryTextColor.withOpacity(0.8),
                      ),
                ),
                leading: Icon(
                  Icons.info_outline,
                  size: 26,
                  color: themeController.isLightMode.value
                      ? kLightPrimaryTextColor.withOpacity(0.8)
                      : kprimaryTextColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
