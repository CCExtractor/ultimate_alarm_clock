import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/share_dialog.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class ShareAlarm extends StatelessWidget {
  const ShareAlarm({
    super.key,
    required this.controller,
    required this.width,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Only show if shared alarms are enabled and current user is NOT the owner
      final isSharedEnabled = controller.isSharedAlarmEnabled.value;
      final isOwner = controller.alarmRecord.value.ownerId ==
          controller.userModel.value?.id;

      if (isSharedEnabled && isOwner) {
        return ListTile(
          onTap: () {
            Utils.hapticFeedback();
            Get.dialog(
              ShareDialog(
                homeController: controller.homeController,
                controller: controller,
                themeController: controller.themeController,
              ),
            );
          },
          title: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              'Share Alarm'.tr,
              style: TextStyle(
                color: themeController.primaryTextColor.value,
              ),
            ),
          ),
          trailing: Icon(
            Icons.switch_access_shortcut_add_outlined,
            color: themeController.primaryTextColor.value.withOpacity(0.7),
          ),
        );
      }

      return const SizedBox();
    });
  }
}
