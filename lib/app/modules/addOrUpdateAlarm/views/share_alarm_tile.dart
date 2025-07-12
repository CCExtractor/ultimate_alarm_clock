import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/share_dialog.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';

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
      // Only show if shared alarms are enabled and current user is the owner
      final isSharedEnabled = controller.isSharedAlarmEnabled.value;
      final isOwner = controller.alarmRecord.value.ownerId ==
          controller.userModel.value?.id;

      if (isSharedEnabled && isOwner) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: themeController.secondaryBackgroundColor.value.withOpacity(0.3),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kprimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.share_rounded,
                color: kprimaryColor,
                size: 20,
              ),
            ),
            onTap: () {
              Utils.hapticFeedback();
              Get.dialog(
                ShareDialog(
                  homeController: controller.homeController,
                  controller: controller,
                  themeController: controller.themeController,
                ),
                barrierDismissible: true,
              );
            },
            title: Text(
              'Share Alarm'.tr,
              style: TextStyle(
                color: themeController.primaryTextColor.value,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Invite others to join this alarm'.tr,
              style: TextStyle(
                color: themeController.primaryTextColor.value.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: themeController.primaryTextColor.value.withOpacity(0.7),
              size: 16,
            ),
          ),
        );
      }

      return const SizedBox();
    });
  }
}