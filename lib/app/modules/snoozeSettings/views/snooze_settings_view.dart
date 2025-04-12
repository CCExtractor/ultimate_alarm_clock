import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/snoozeSettings/controllers/snooze_settings_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class SnoozeSettingsView extends GetView<SnoozeSettingsController> {
  const SnoozeSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.themeController.primaryBackgroundColor.value,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: controller.themeController.primaryBackgroundColor.value,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: controller.themeController.primaryTextColor.value,
          ),
          onPressed: () {
            Utils.hapticFeedback();
            Get.back();
          },
        ),
        title: Text(
          'Snooze Settings',
          style: TextStyle(
            color: controller.themeController.primaryTextColor.value,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.hapticFeedback();
              controller.saveSettings();
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: kprimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() => ListView(
            children: [
              _buildCombinedSnoozeSection(),
              _buildDivider(),
            ],
          )),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade800,
    );
  }

  Widget _buildCombinedSnoozeSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Snooze Settings',
            style: TextStyle(
              color: controller.themeController.primaryTextColor.value,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duration',
                    style: TextStyle(
                      color: controller.themeController.primaryTextColor.value,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Minutes per snooze',
                    style: TextStyle(
                      color: controller.themeController.primaryDisabledTextColor.value,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCircleButton(
                    icon: Icons.remove,
                    onTap: () {
                      Utils.hapticFeedback();
                      controller.decrementValue(controller.snoozeDuration, 0);
                    },
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${controller.snoozeDuration.value}',
                    style: TextStyle(
                      color: controller.themeController.primaryTextColor.value,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildCircleButton(
                    icon: Icons.add,
                    onTap: () {
                      Utils.hapticFeedback();
                      controller.incrementValue(controller.snoozeDuration, 60);
                    },
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maximum Snoozes',
                    style: TextStyle(
                      color: controller.themeController.primaryTextColor.value,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Limit count',
                    style: TextStyle(
                      color: controller.themeController.primaryDisabledTextColor.value,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCircleButton(
                    icon: Icons.remove,
                    onTap: () {
                      Utils.hapticFeedback();
                      controller.decrementValue(controller.maxSnoozeCount, 1);
                    },
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${controller.maxSnoozeCount.value}',
                    style: TextStyle(
                      color: controller.themeController.primaryTextColor.value,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildCircleButton(
                    icon: Icons.add,
                    onTap: () {
                      Utils.hapticFeedback();
                      controller.incrementValue(controller.maxSnoozeCount, 10);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: controller.themeController.primaryTextColor.value,
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: controller.themeController.primaryTextColor.value,
            size: 24,
          ),
        ),
      ),
    );
  }
} 