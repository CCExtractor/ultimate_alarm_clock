import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/providers/google_cloud_api_provider.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/share_dialog.dart';

import '../../../utils/constants.dart';

class SettingSelector extends StatelessWidget {
  SettingSelector({super.key});
  AddOrUpdateAlarmController controller =
      Get.find<AddOrUpdateAlarmController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Option(0, Icons.alarm, 'Alarm'),
          Option(1, Icons.auto_awesome, 'Smart-Controls'),
          Option(2, Icons.checklist_rounded, 'Challenges'),
          Option(3, Icons.share, 'Share'),
        ],
      ),
    );
  }

  Widget Option(int val, IconData icon, String name) {
    return Obx(
      () => Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(28.r),
              onTap: () async {
                if (name == 'Share') {
                  final isLoggedIn = await GoogleCloudProvider.isUserLoggedin();
                  if (isLoggedIn) {
                    Get.dialog(ShareDialog(
                      homeController: controller.homeController,
                      controller: controller,
                      themeController: controller.themeController,
                    ));
                  } else {
                    await GoogleCloudProvider.getInstance();
                  }
                  ;
                } else {
                  controller.alarmSettingType.value = val;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: controller.alarmSettingType.value == val
                      ? kprimaryColor
                      : controller
                          .themeController.secondaryBackgroundColor.value,
                  borderRadius: BorderRadius.circular(20.roundToDouble()),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: Icon(
                    size: 24.r,
                    icon,
                    color: controller.alarmSettingType.value == val
                        ? kLightPrimaryTextColor
                        : controller
                            .themeController.primaryDisabledTextColor.value,
                  ),
                ),
              ),
            ),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
