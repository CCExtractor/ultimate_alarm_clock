import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/data/models/task_model.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/task_list_editor_page.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:uuid/uuid.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            if (controller.isTaskListEnabled.value) {
              _openTaskListEditor(context);
            }
          },
          title: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Obx(
                  () => Text(
                    'Task List'.tr,
                    style: TextStyle(
                      color: themeController.primaryTextColor.value,
                    ),
                  ),
                ),
              ),
              Obx(
                () => IconButton(
                  icon: Icon(
                    Icons.info_sharp,
                    size: 21,
                    color: themeController.primaryTextColor.value.withOpacity(0.3),
                  ),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Task List'.tr,
                      middleText: 'Add a small, customizable to-do list that will be displayed when the alarm goes off, reminding you of important tasks or goals right at wake-up.'.tr,
                      backgroundColor: themeController.secondaryBackgroundColor.value,
                      titleStyle: TextStyle(color: themeController.primaryTextColor.value),
                      middleTextStyle: TextStyle(color: themeController.primaryTextColor.value),
                      radius: 8,
                    );
                  },
                ),
              ),
            ],
          ),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () {
                  return Switch.adaptive(
                    value: controller.isTaskListEnabled.value,
                    activeColor: ksecondaryColor,
                    onChanged: (value) {
                      controller.isTaskListEnabled.value = value;
                      if (value && controller.taskList.isEmpty) {
                        _openTaskListEditor(context);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Obx(() => controller.isTaskListEnabled.value && controller.taskList.isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...controller.taskList.map((task) => _buildTaskItem(task, context)),
                    TextButton(
                      onPressed: () => _openTaskListEditor(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, size: 16, color: themeController.primaryColor.value),
                          const SizedBox(width: 4),
                          Text(
                            'Edit Tasks'.tr,
                            style: TextStyle(color: themeController.primaryColor.value),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildTaskItem(TaskModel task, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: themeController.primaryTextColor.value,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.text,
              style: TextStyle(
                color: themeController.primaryTextColor.value,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openTaskListEditor(BuildContext context) {
    Get.to(
      () => TaskListEditorPage(
        controller: controller,
        themeController: themeController,
      ),
      transition: Transition.rightToLeft,
    );
  }
} 