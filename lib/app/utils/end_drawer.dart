import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/routes/app_pages.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/modules/debug/views/debug_view.dart';
import 'package:ultimate_alarm_clock/app/modules/debug/views/debug_view.dart';
import 'package:ultimate_alarm_clock/app/modules/debug/controllers/debug_controller.dart';

Widget buildEndDrawer(BuildContext context) {
  ThemeController themeController = Get.find<ThemeController>();
  return Obx(
    () => Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      backgroundColor: themeController.secondaryBackgroundColor.value,
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
                          width: Get.width * 0.5,
                          child: Text(
                            'Ultimate Alarm Clock'.tr,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: themeController
                                      .primaryBackgroundColor.value,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.5,
                          child: Text(
                            'v0.2.1'.tr,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: themeController.primaryTextColor.value,
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
              Get.toNamed(Routes.DEBUG);
            },
            contentPadding: const EdgeInsets.only(left: 20, right: 44),
            title: Text(
              'Debug Logs'.tr,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color:
                        themeController.primaryTextColor.value.withOpacity(0.8),
                  ),
            ),
            leading: Icon(
              Icons.bug_report,
              size: 26,
              color: themeController.primaryTextColor.value.withOpacity(0.8),
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
                    color:
                        themeController.primaryTextColor.value.withOpacity(0.8),
                  ),
            ),
            leading: Icon(
              Icons.settings,
              size: 26,
              color: themeController.primaryTextColor.value.withOpacity(0.8),
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
                    color:
                        themeController.primaryTextColor.value.withOpacity(0.8),
                  ),
            ),
            leading: Icon(
              Icons.info_outline,
              size: 26,
              color: themeController.primaryTextColor.value.withOpacity(0.8),
            ),
          ),
        ],
      ),
    ),
  );
}
