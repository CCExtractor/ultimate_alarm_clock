import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/data/providers/isar_provider.dart';
import 'package:ultimate_alarm_clock/app/data/providers/firestore_provider.dart';

import '../controllers/alarm_ring_controller.dart';

// ignore: must_be_immutable
class AlarmControlView extends GetView<AlarmControlController> {
  AlarmControlView({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  Obx getAddSnoozeButtons(
      BuildContext context, int snoozeMinutes, String title) {
    return Obx(
      () => TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            themeController.secondaryBackgroundColor.value,
          ),
        ),
        child: Text(
          title.tr,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: themeController.primaryTextColor.value,
                fontWeight: FontWeight.w600,
              ),
        ),
        onPressed: () {
          Utils.hapticFeedback();
          controller.addMinutes(snoozeMinutes);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }

        Get.snackbar(
          'Note'.tr,
          "You can't go back while the alarm is ringing".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.04),
                      child: Obx(
                        () => Column(
                          children: [
                            Text(
                              controller.formattedDate.value,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: 10,
                              width: 0,
                            ),
                            Text(
                              (controller.isSnoozing.value)
                                  ? "${controller.minutes.toString().padLeft(2, '0')}"
                                      ":${controller.seconds.toString().padLeft(2, '0')}"
                                  : (controller.is24HourFormat.value)
                                      ? '${controller.timeNow24Hr}'
                                      : '${controller.timeNow[0]} ${controller.timeNow[1]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(fontSize: 50),
                            ),
                            const SizedBox(
                              height: 20,
                              width: 0,
                            ),
                            Obx(
                              () => Visibility(
                                visible: controller.isSnoozing.value,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    getAddSnoozeButtons(context, 1, '+1 min'),
                                    getAddSnoozeButtons(context, 2, '+2 min'),
                                    getAddSnoozeButtons(context, 5, '+5 min'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Note
                            Obx(
                              () {
                                return Visibility(
                                  visible: controller
                                      .currentlyRingingAlarm.value.note.isNotEmpty,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: Text(
                                      controller.currentlyRingingAlarm.value.note,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: themeController.primaryTextColor.value,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w100,
                                            fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            Obx(
                              () => Visibility(
                                visible: controller.hasTaskList.value,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: themeController.secondaryBackgroundColor.value,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.task_alt_rounded,
                                            color: kprimaryColor,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Today\'s Tasks'.tr,
                                            style: TextStyle(
                                              color: themeController.primaryTextColor.value,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Obx(() {
                                        int completedTasks = controller.taskList
                                            .where((task) => task.completed)
                                            .length;
                                        int totalTasks = controller.taskList.length;
                                        
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: LinearProgressIndicator(
                                                    value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                                                    backgroundColor: themeController.primaryBackgroundColor.value,
                                                    valueColor: AlwaysStoppedAnimation<Color>(kprimaryColor),
                                                    minHeight: 8,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                '$completedTasks/$totalTasks',
                                                style: TextStyle(
                                                  color: themeController.primaryTextColor.value,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      const SizedBox(height: 10),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: height * 0.2, 
                                        ),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: controller.taskList.length,
                                          itemBuilder: (context, index) {
                                            var task = controller.taskList[index];
                                            return AnimatedContainer(
                                              duration: const Duration(milliseconds: 300),
                                              margin: const EdgeInsets.only(bottom: 8.0),
                                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: task.completed 
                                                    ? kprimaryColor.withOpacity(0.15)
                                                    : themeController.primaryBackgroundColor.value.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Transform.scale(
                                                    scale: 1.2,
                                                    child: Checkbox(
                                                      value: task.completed,
                                                      activeColor: kprimaryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      onChanged: (bool? value) {
                                                        controller.toggleTaskCompletion(index);
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      task.text,
                                                      style: TextStyle(
                                                        color: themeController.primaryTextColor.value,
                                                        fontSize: 16,
                                                        decoration: task.completed ? TextDecoration.lineThrough : null,
                                                        decorationColor: kprimaryColor,
                                                        decorationThickness: 2,
                                                        fontWeight: task.completed ? FontWeight.normal : FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => Visibility(
                            visible: !controller.isSnoozing.value,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: SizedBox(
                                height: height * 0.07,
                                width: width * 0.5,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      themeController.secondaryBackgroundColor.value,
                                    ),
                                  ),
                                  child: Text(
                                    'Snooze'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: themeController.primaryTextColor.value,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  onPressed: () {
                                    Utils.hapticFeedback();
                                    controller.startSnooze();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        Obx(
                          () => Visibility(
                            visible: controller.showButton.value,
                            child: SizedBox(
                              height: height * 0.07,
                              width: width * 0.8,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    kprimaryColor,
                                  ),
                                ),
                                onPressed: () async {
                                  Utils.hapticFeedback();
                                  if (controller.currentlyRingingAlarm.value.isGuardian) {
                                    controller.guardianTimer.cancel();
                                  }
                                  
                                  if (controller.currentlyRingingAlarm.value.days.every((element) => element == false)) {
                                    controller.currentlyRingingAlarm.value.isEnabled = false;
                                    if (controller.currentlyRingingAlarm.value.isSharedAlarmEnabled == false) {
                                      await IsarDb.updateAlarm(controller.currentlyRingingAlarm.value);
                                    } else {
                                      await FirestoreDb.updateAlarm(
                                        controller.currentlyRingingAlarm.value.ownerId,
                                        controller.currentlyRingingAlarm.value,
                                      );
                                    }
                                  }
                                  if (Utils.isChallengeEnabled(
                                    controller.currentlyRingingAlarm.value,
                                  )) {
                                    Get.toNamed(
                                      '/alarm-challenge',
                                      arguments: controller.currentlyRingingAlarm.value,
                                    );
                                  } else {
                                    Get.offAllNamed(
                                      '/bottom-navigation-bar',
                                      arguments: controller.currentlyRingingAlarm.value,
                                    );
                                  }
                                },
                                child: Text(
                                  Utils.isChallengeEnabled(
                                    controller.currentlyRingingAlarm.value,
                                  )
                                      ? 'Start Challenge'.tr
                                      : 'Dismiss'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: themeController.secondaryTextColor.value,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Exit Preview button - only show in preview mode
              if (controller.isPreviewMode.value)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    color: Colors.red,
                    child: TextButton(
                      onPressed: () {
                        Utils.hapticFeedback();
                        Get.offAllNamed('/bottom-navigation-bar');
                      },
                      child: Text(
                        'Exit Preview'.tr,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
