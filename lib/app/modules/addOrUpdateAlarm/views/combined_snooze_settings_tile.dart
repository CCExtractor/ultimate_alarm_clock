import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class CombinedSnoozeSettingsTile extends StatelessWidget {
  const CombinedSnoozeSettingsTile({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Utils.hapticFeedback();
        // Store initial values
        final int duration = controller.snoozeDuration.value;
        final int count = controller.maxSnoozeCount.value;
        
        // Instead of using a dialog, navigate to a full screen
        Get.to(
          () => SnoozeSettingsScreen(
            controller: controller,
            themeController: themeController,
            initialDuration: duration,
            initialCount: count,
          ),
        );
      },
      child: ListTile(
        title: Text(
          'Snooze Settings'.tr,
          style: TextStyle(
            color: themeController.primaryTextColor.value,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(
              controller.snoozeDuration.value > 0
                  ? '${controller.snoozeDuration.value}min / ${controller.maxSnoozeCount.value}×'
                  : 'Off'.tr,
              style: TextStyle(
                color: (controller.snoozeDuration.value <= 0)
                    ? themeController.primaryDisabledTextColor.value
                    : themeController.primaryTextColor.value,
              ),
            )),
            Icon(
              Icons.chevron_right,
              color: themeController.primaryDisabledTextColor.value,
            ),
          ],
        ),
      ),
    );
  }
}

// Full screen settings page for snooze settings
class SnoozeSettingsScreen extends StatelessWidget {
  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;
  final int initialDuration;
  final int initialCount;

  const SnoozeSettingsScreen({
    Key? key,
    required this.controller,
    required this.themeController,
    required this.initialDuration,
    required this.initialCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.primaryBackgroundColor.value,
      appBar: AppBar(
        backgroundColor: themeController.primaryBackgroundColor.value,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeController.primaryTextColor.value,
          ),
          onPressed: () {
            Utils.hapticFeedback();
            // Cancel changes and restore original values
            controller.snoozeDuration.value = initialDuration;
            controller.maxSnoozeCount.value = initialCount;
            Get.back();
          },
        ),
        title: Text(
          'Snooze Settings',
          style: TextStyle(
            color: themeController.primaryTextColor.value,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.hapticFeedback();
              Get.back();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Duration section
            _buildDurationSection(context),
            Divider(
              color: Colors.grey.shade800,
              height: 1,
              thickness: 1,
            ),
            // Max snooze count section
            _buildMaxSnoozeSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSection(BuildContext context) {
    return _buildSectionContainer(
      title: 'Duration',
      subtitle: 'Snooze button will appear when alarm rings',
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Obx(() => NumberPicker(
                value: controller.snoozeDuration.value <= 0
                    ? 0
                    : controller.snoozeDuration.value,
                minValue: 0,
                maxValue: 60,
                step: 1,
                infiniteLoop: true,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: themeController.primaryDisabledTextColor.value,
                ),
                selectedTextStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: kprimaryColor,
                ),
                onChanged: (value) {
                  Utils.hapticFeedback();
                  controller.snoozeDuration.value = value;
                },
              )),
            ),
            Obx(() => Text(
              controller.snoozeDuration.value == 1 ? 'minute' : 'minutes',
              style: TextStyle(
                fontSize: 16,
                color: themeController.primaryTextColor.value,
              ),
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMaxSnoozeSection(BuildContext context) {
    return _buildSectionContainer(
      title: 'Maximum Snooze Count',
      subtitle: 'Limit to snoozes',
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircleButton(
              icon: Icons.remove,
              onTap: () {
                Utils.hapticFeedback();
                if (controller.maxSnoozeCount.value > 1) {
                  controller.maxSnoozeCount.value--;
                }
              },
            ),
            const SizedBox(width: 40),
            Obx(() => Text(
              '${controller.maxSnoozeCount.value}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: themeController.primaryTextColor.value,
              ),
            )),
            const SizedBox(width: 40),
            _buildCircleButton(
              icon: Icons.add,
              onTap: () {
                Utils.hapticFeedback();
                if (controller.maxSnoozeCount.value < 10) {
                  controller.maxSnoozeCount.value++;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: themeController.primaryDisabledTextColor.value,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          child,
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
            color: themeController.primaryTextColor.value,
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: themeController.primaryTextColor.value,
            size: 24,
          ),
        ),
      ),
    );
  }
} 