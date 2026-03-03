import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/views/system_ringtone_picker.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/audio_utils.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';
import 'package:ultimate_alarm_clock/app/utils/system_ringtone_service.dart';

class RingtoneSelectionPage extends GetView<AddOrUpdateAlarmController> {
  final ThemeController themeController = Get.find<ThemeController>();

  RingtoneSelectionPage({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRingtones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          await _stopAllAudio();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Obx(
          () => Scaffold(
            backgroundColor: themeController.primaryBackgroundColor.value,
            appBar: AppBar(
              backgroundColor: themeController.primaryBackgroundColor.value,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: themeController.primaryTextColor.value,
                ),
                onPressed: () async {
                  await _stopAllAudio();
                  Get.back();
                },
                tooltip: 'Back',
              ),
              title: Text(
                'Choose Ringtone'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w600,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight + 8),
                child: Column(
                  children: [
                    // Enhanced tab bar with better spacing and styling
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: themeController.secondaryBackgroundColor.value,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: themeController.primaryDisabledTextColor.value
                              .withOpacity(0.1),
                        ),
                      ),
                      child: TabBar(
                        labelColor: kprimaryColor,
                        unselectedLabelColor: 
                            themeController.primaryDisabledTextColor.value,
                        indicatorColor: kprimaryColor,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: kprimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.library_music,
                              size: 20,
                            ),
                            text: 'Custom'.tr,
                            height: 60,
                          ),
                          Tab(
                            icon: Icon(
                              Icons.phone_android,
                              size: 20,
                            ),
                            text: 'System'.tr,
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                _buildCustomRingtonesTab(context),
                _buildSystemRingtonesTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _stopAllAudio() async {
    await AudioUtils.stopPreviewCustomSound();
    await SystemRingtoneService.stopSystemRingtone();
    controller.isPlaying.value = false;
    controller.playingSystemRingtoneUri.value = '';
  }

  Future<void> _loadRingtones() async {
    controller.customRingtoneNames.value =
        await controller.getAllCustomRingtoneNames();
  }

  void _onTapPreview(String ringtoneName) async {
    Utils.hapticFeedback();

    if (controller.isPlaying.value == true) {
      await AudioUtils.stopPreviewCustomSound();
      controller.toggleIsPlaying();
    } else {
      await AudioUtils.previewCustomSound(ringtoneName);
      controller.toggleIsPlaying();
    }
  }

  Widget _buildCustomRingtonesTab(BuildContext context) {
    return Column(
      children: [
        // Enhanced header with upload button
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: themeController.secondaryBackgroundColor.value,
            border: Border(
              bottom: BorderSide(
                color: themeController.primaryDisabledTextColor.value
                    .withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.library_music,
                    color: themeController.primaryTextColor.value,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Custom Ringtones'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: themeController.primaryTextColor.value,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      '${controller.customRingtoneNames.length} ${controller.customRingtoneNames.length == 1 ? 'ringtone' : 'ringtones'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: themeController.primaryDisabledTextColor.value,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Utils.hapticFeedback();
                    await _stopAllAudio();
                    controller.previousRingtone = controller.customRingtoneName.value;
                    await controller.saveCustomRingtone();
                    await _loadRingtones();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.upload_file, size: 20),
                  label: Text(
                    'Upload Ringtone'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Ringtone list
        Expanded(
          child: Obx(
            () => controller.customRingtoneNames.isEmpty
                ? _buildEmptyState(context)
                : RefreshIndicator(
                    color: kprimaryColor,
                    onRefresh: _loadRingtones,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.customRingtoneNames.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final ringtoneName = controller.customRingtoneNames[index];
                        return Obx(() => _buildRingtoneListItem(
                          context: context,
                          ringtoneName: ringtoneName,
                          index: index,
                          isSelected: controller.customRingtoneName.value == ringtoneName,
                          isPlaying: controller.isPlaying.value && 
                                    controller.customRingtoneName.value == ringtoneName,
                        ));
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemRingtonesTab() {
    return SystemRingtonePicker(
      isFullScreen: true,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: themeController.secondaryBackgroundColor.value,
                shape: BoxShape.circle,
                border: Border.all(
                  color: themeController.primaryDisabledTextColor.value
                      .withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.library_music,
                size: 48,
                color: themeController.primaryDisabledTextColor.value,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No custom ringtones'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: themeController.primaryTextColor.value,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your favorite sounds to personalize your alarms'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: themeController.primaryDisabledTextColor.value,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () async {
                Utils.hapticFeedback();
                await _stopAllAudio();
                controller.previousRingtone = controller.customRingtoneName.value;
                await controller.saveCustomRingtone();
                await _loadRingtones();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: kprimaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                Icons.upload_file,
                color: kprimaryColor,
                size: 20,
              ),
              label: Text(
                'Upload Ringtone'.tr,
                style: TextStyle(
                  color: kprimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRingtoneListItem({
    required BuildContext context,
    required String ringtoneName,
    required int index,
    required bool isSelected,
    required bool isPlaying,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? kprimaryColor.withOpacity(0.08)
            : themeController.secondaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? kprimaryColor
              : themeController.primaryDisabledTextColor.value.withOpacity(0.12),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: kprimaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            Utils.hapticFeedback();
            await _stopAllAudio();
            controller.previousRingtone = controller.customRingtoneName.value;

            controller.customRingtoneName.value = ringtoneName;

            if (controller.customRingtoneName.value != controller.previousRingtone) {
              await AudioUtils.updateRingtoneCounterOfUsage(
                customRingtoneName: controller.customRingtoneName.value,
                counterUpdate: CounterUpdate.increment,
              );

              await AudioUtils.updateRingtoneCounterOfUsage(
                customRingtoneName: controller.previousRingtone,
                counterUpdate: CounterUpdate.decrement,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Leading indicator
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? kprimaryColor 
                        : themeController.primaryBackgroundColor.value,
                    shape: BoxShape.circle,
                    border: isSelected ? null : Border.all(
                      color: themeController.primaryDisabledTextColor.value
                          .withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    isSelected ? Icons.check_circle : Icons.music_note,
                    color: isSelected 
                        ? Colors.white 
                        : themeController.primaryTextColor.value,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Ringtone name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ringtoneName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: themeController.primaryTextColor.value,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isSelected) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Current ringtone'.tr,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: kprimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Preview button - always visible, but only functional when selected
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected && isPlaying 
                            ? Colors.red.withOpacity(0.1) 
                            : isSelected 
                                ? kprimaryColor.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: isSelected ? () => _onTapPreview(ringtoneName) : null,
                        icon: Icon(
                          isSelected && isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          color: isSelected 
                              ? (isPlaying ? Colors.red : kprimaryColor)
                              : themeController.primaryDisabledTextColor.value,
                          size: 28,
                        ),
                        tooltip: isSelected 
                            ? (isPlaying ? 'Stop preview'.tr : 'Play preview'.tr)
                            : 'Select to preview'.tr,
                      ),
                    ),
                    
                    // Delete button (only for non-default ringtones)
                    if (!defaultRingtones.contains(ringtoneName)) ...[
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () async {
                          Utils.hapticFeedback();
                          final bool? shouldDelete = await _showDeleteConfirmation(ringtoneName);
                          if (shouldDelete == true) {
                            await controller.deleteCustomRingtone(
                              ringtoneName: ringtoneName,
                              ringtoneIndex: index,
                            );
                            await _loadRingtones();
                          }
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.withOpacity(0.7),
                          size: 20,
                        ),
                        tooltip: 'Delete ringtone'.tr,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(String ringtoneName) async {
    return showDialog<bool>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeController.secondaryBackgroundColor.value,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete ringtone?'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete'.tr,
                style: TextStyle(
                  color: themeController.primaryDisabledTextColor.value,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '"$ringtoneName"?',
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone.'.tr,
                style: TextStyle(
                  color: themeController.primaryDisabledTextColor.value,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel'.tr,
                style: TextStyle(
                  color: themeController.primaryTextColor.value,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Delete'.tr),
            ),
          ],
        );
      },
    );
  }
}