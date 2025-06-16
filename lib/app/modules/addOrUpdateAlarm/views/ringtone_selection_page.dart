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
          await AudioUtils.stopPreviewCustomSound();
          await SystemRingtoneService.stopSystemRingtone();
          controller.isPlaying.value = false;
          controller.playingSystemRingtoneUri.value = '';
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
        backgroundColor: themeController.secondaryBackgroundColor.value,
        appBar: AppBar(
          backgroundColor: themeController.secondaryBackgroundColor.value,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: themeController.primaryTextColor.value,
            ),
            onPressed: () async {
              await AudioUtils.stopPreviewCustomSound();
              await SystemRingtoneService.stopSystemRingtone();
              controller.isPlaying.value = false;
              controller.playingSystemRingtoneUri.value = '';
              Get.back();
            },
          ),
          title: Text(
            'Choose Ringtone'.tr,
            style: TextStyle(
              color: themeController.primaryTextColor.value,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            labelColor: kprimaryColor,
            unselectedLabelColor: themeController.primaryTextColor.value,
            indicatorColor: kprimaryColor,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: Icon(Icons.music_note),
                text: 'Custom Ringtones',
              ),
              Tab(
                icon: Icon(Icons.phone_android),
                text: 'System Ringtones',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCustomRingtonesTab(),
            _buildSystemRingtonesTab(),
          ],
        ),
        ),
      ),
    );
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

  Widget _buildCustomRingtonesTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Utils.hapticFeedback();
                    await AudioUtils.stopPreviewCustomSound();
                    controller.isPlaying.value = false;
                    controller.previousRingtone = controller.customRingtoneName.value;
                    await controller.saveCustomRingtone();
                    await _loadRingtones();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(Icons.upload_file),
                  label: Text('Upload Ringtone'.tr),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Obx(
            () => controller.customRingtoneNames.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.customRingtoneNames.length,
                    itemBuilder: (context, index) {
                      final ringtoneName = controller.customRingtoneNames[index];
                      return Obx(() => _buildRingtoneListItem(
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
      ],
    );
  }

  Widget _buildSystemRingtonesTab() {
    return SystemRingtonePicker(
      isFullScreen: true,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            size: 64,
            color: themeController.primaryTextColor.value.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No custom ringtones found',
            style: TextStyle(
              color: themeController.primaryTextColor.value.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your first ringtone to get started',
            style: TextStyle(
              color: themeController.primaryTextColor.value.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRingtoneListItem({
    required String ringtoneName,
    required int index,
    required bool isSelected,
    required bool isPlaying,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? kprimaryColor.withOpacity(0.1)
            : themeController.primaryBackgroundColor.value,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? kprimaryColor
              : themeController.primaryTextColor.value.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () async {
          await AudioUtils.stopPreviewCustomSound();
          controller.isPlaying.value = false;
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
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? kprimaryColor : themeController.primaryTextColor.value.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isSelected ? Icons.radio_button_checked : Icons.music_note,
            color: isSelected ? Colors.white : themeController.primaryTextColor.value,
            size: 20,
          ),
        ),
        title: Text(
          ringtoneName,
          style: TextStyle(
            color: themeController.primaryTextColor.value,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              IconButton(
                onPressed: () => _onTapPreview(ringtoneName),
                icon: Icon(
                  isPlaying ? Icons.stop_circle : Icons.play_circle,
                  color: isPlaying ? Colors.red : kprimaryColor,
                  size: 28,
                ),
              ),
            if (!defaultRingtones.contains(ringtoneName))
              IconButton(
                onPressed: () async {
                  await controller.deleteCustomRingtone(
                    ringtoneName: ringtoneName,
                    ringtoneIndex: index,
                  );
                  await _loadRingtones();
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red.withOpacity(0.8),
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}