import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/alarmHistory/controllers/alarm_history_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class AlarmHistoryView extends GetView<AlarmHistoryController> {

  final AlarmHistoryController controller = Get.find<AlarmHistoryController>();
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Alarm history'.tr,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Obx(
            () => Icon(
              Icons.adaptive.arrow_back,
              color: themeController.primaryTextColor.value,
            ),
          ),
          onPressed: () {
            Utils.hapticFeedback();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Obx(()  => Center(
          child: controller.history.value.isEmpty
          ? Text('History is empty.')
          : Text('History is not empty.'),
        )
      ),
    );
  }
  
}