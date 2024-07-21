import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';

import '../../../utils/constants.dart';

class SettingSelector extends StatelessWidget {
  SettingSelector({super.key});
  AddOrUpdateAlarmController controller =
      Get.find<AddOrUpdateAlarmController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: controller.homeController.scalingFactor.value * 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Option(0, Icons.alarm, "Alarm"),
          Option(1, Icons.auto_awesome, "Auto-Cancel"),
          Option(2, Icons.checklist_rounded, "Challenges"),
          Option(3, Icons.share, "Share")
        ],
      ),
    );
  }

  Widget Option(int val, IconData icon, String name) {
    return Obx(() => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () {
                  controller.alarmSettingType.value = val;
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: controller.alarmSettingType.value == val
                            ? kprimaryColor
                            : ksecondaryBackgroundColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        icon,
                        color: controller.alarmSettingType.value == val
                            ? ksecondaryBackgroundColor
                            : Colors.white,
                      ),
                    )),
              ),
            ),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: controller.homeController.scalingFactor.value * 12),
            ),
          ],
        ));
  }
}
