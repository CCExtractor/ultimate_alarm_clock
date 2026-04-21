import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/controllers/pomodoro_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class PomodoroTabView extends GetView<PomodoroController> {
  PomodoroTabView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTopSummary(context),
              _buildCenterTimer(context),
              _buildBottomControls(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: kprimaryColor.withOpacity(0.15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lens, size: 12, color: kprimaryColor),
              const SizedBox(width: 8),
              Text(
                '${controller.phaseLabel} • ${'Session'.tr} ${controller.currentSession.value}/${controller.totalSessions.value}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: kprimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCenterTimer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Utils.formatMilliseconds(controller.displayRemainingMs),
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: themeController.primaryTextColor.value,
                fontWeight: FontWeight.w300,
                fontSize: 84,
              ),
        ),
        const SizedBox(height: 24),
        if (controller.isActive)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: controller.progress.clamp(0.0, 1.0),
                backgroundColor: themeController.secondaryBackgroundColor.value,
                valueColor: const AlwaysStoppedAnimation<Color>(kprimaryColor),
              ),
            ),
          )
        else
          InkWell(
            onTap: () => _showSetupBottomSheet(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: themeController.secondaryBackgroundColor.value,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune,
                    size: 20,
                    color: themeController.primaryDisabledTextColor.value,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${controller.workMinutes.value}m / ${controller.shortBreakMinutes.value}m / ${controller.totalSessions.value} ${'sessions'.tr}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: themeController.primaryTextColor.value,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (controller.isActive) ...[
            _buildCircularButton(
              context: context,
              icon: Icons.skip_next_rounded,
              color: themeController.secondaryBackgroundColor.value,
              iconColor: themeController.primaryDisabledTextColor.value,
              onPressed: controller.canSkip ? controller.skipPhase : null,
            ),
            const SizedBox(width: 24),
          ],
          _buildCircularButton(
            context: context,
            icon: controller.canPause
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            color: kprimaryColor,
            iconColor: ksecondaryBackgroundColor,
            isLarge: true,
            onPressed: () {
              if (controller.canPause) {
                controller.pausePomodoro();
              } else {
                controller.startOrResumePomodoro();
              }
            },
          ),
          if (controller.isActive) ...[
            const SizedBox(width: 24),
            _buildCircularButton(
              context: context,
              icon: Icons.refresh_rounded,
              color: themeController.secondaryBackgroundColor.value,
              iconColor: themeController.primaryDisabledTextColor.value,
              onPressed: controller.resetPomodoro,
            ),
          ] else ...[
            // Keep layout balanced when not active
            const SizedBox(width: 24),
            SizedBox(
              height: 60,
              width: 60,
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: themeController.primaryDisabledTextColor.value,
                ),
                onPressed: () => _showSetupBottomSheet(context),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback? onPressed,
    bool isLarge = false,
  }) {
    final double size = isLarge ? 80 : 60;
    final double iconSize = isLarge ? 40 : 28;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onPressed == null ? color.withOpacity(0.5) : color,
        ),
        child: Icon(
          icon,
          color: onPressed == null ? iconColor.withOpacity(0.5) : iconColor,
          size: iconSize,
        ),
      ),
    );
  }

  void _showSetupBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: themeController.secondaryBackgroundColor.value,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pomodoro Setup'.tr,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: themeController.primaryTextColor.value,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _durationPicker(
                    context: context,
                    title: 'Work'.tr,
                    value: controller.workMinutes.value,
                    minValue: 1,
                    maxValue: 120,
                    onChanged: controller.updateWorkMinutes,
                  ),
                  _durationPicker(
                    context: context,
                    title: 'Break'.tr,
                    value: controller.shortBreakMinutes.value,
                    minValue: 1,
                    maxValue: 60,
                    onChanged: controller.updateShortBreakMinutes,
                  ),
                  _durationPicker(
                    context: context,
                    title: 'Sessions'.tr,
                    value: controller.totalSessions.value,
                    minValue: 1,
                    maxValue: 12,
                    onChanged: controller.updateTotalSessions,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    foregroundColor: ksecondaryBackgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    'Done'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _durationPicker({
    required BuildContext context,
    required String title,
    required int value,
    required int minValue,
    required int maxValue,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: themeController.primaryDisabledTextColor.value,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        NumberPicker(
          minValue: minValue,
          maxValue: maxValue,
          value: value,
          onChanged: onChanged,
          itemWidth: 60,
          itemHeight: 40,
          selectedTextStyle:
              Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: kprimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
          textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: themeController.primaryDisabledTextColor.value,
              ),
          axis: Axis.vertical,
        ),
      ],
    );
  }
}
